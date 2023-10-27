//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Combine
import CoreLocation
import Foundation

@MainActor
final class CurrentWeatherViewModel: CurrentWeatherViewModelProtocol {

    let titleText: String = L10n.CurrentWeather.title
    let apiAlertTitle: String = L10n.CurrentWeather.KeyAlert.title
    let apiAlertDescription: String = L10n.CurrentWeather.KeyAlert.description
    let apiAlertOk: String = L10n.CurrentWeather.KeyAlert.confirmText
    let selectLocationButtonText: String = L10n.CurrentWeather.CustomLocationButton.title
    let deleteKeyButtonText: String = L10n.CurrentWeather.DeleteKeyButton.text
    @Published var temperature: String = ""
    @Published var errorMessage: String = ""
    @Published var apiKey: String = ""
    @Published var isAlertPresented: Bool = false
    @Published var selectedGeoItem: GeoViewModelItem?

    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let measurementFormatter: MeasurementFormatterProtocol
    private let locale: LocaleProvider
    private let notificationCenter: NotificationCenter
    private let apiKeyStorage: ApiKeyStorageProtocol

    private var lastLocation: CLLocation?
    private var lastSuccessfullyFetchedLocation: CLLocation?
    private var userSelectedLocation: CLLocation?
    private var currentTask: Task<(), Error>?
    private var cancellables: Set<AnyCancellable> = []
    private var timerCancellable: Cancellable?

    init(locationService: LocationServiceProtocol,
         weatherService: WeatherServiceProtocol,
         measurementFormatter: MeasurementFormatterProtocol,
         apiKeyStorage: ApiKeyStorageProtocol,
         notificationCenter: NotificationCenter = .default,
         locale: LocaleProvider = Locale.autoupdatingCurrent) {
        self.locationService = locationService
        self.weatherService = weatherService
        self.measurementFormatter = measurementFormatter
        self.apiKeyStorage = apiKeyStorage
        self.notificationCenter = notificationCenter
        self.locale = locale
        bindApiKey()
        bindLocation()
        bindLocale()
        bindSelectedItem()
        restartAndBindTimer()
    }

    func apiKeyUpdatedAction() {
        if let location = lastLocation {
            requestWeather(for: location)
            if !apiKey.isEmpty {
                try? apiKeyStorage.saveApiKey(apiKey)
            }
        }
    }

    func deleteApiKey() {
        apiKey = ""
        apiKeyStorage.deleteKey()
        bindApiKey()
    }
}

private extension CurrentWeatherViewModel {

    private func bindApiKey() {
        apiKey = (try? apiKeyStorage.getKey()) ?? apiKey
        isAlertPresented = apiKey.isEmpty
    }

    private func bindSelectedItem() {
        $selectedGeoItem
            .sink(receiveValue: { [weak self] value in
                guard let value else { return }
                let location = value.location
                self?.userSelectedLocation = location
                self?.lastLocation = location
                self?.locationService.stop()
                self?.requestWeather(for: location)
            })
            .store(in: &cancellables)
    }

    private func bindLocation() {
        locationService
            .locationPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleLocationError(error: error)
                }
            }, receiveValue: { [weak self] in
                self?.handleNewLocation(location: $0)
            })
            .store(in: &cancellables)

        locationService.start()
    }

    private func bindLocale() {
        notificationCenter
            .publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink(receiveValue: { [weak self] notification in
                if let location = self?.lastLocation {
                    self?.requestWeather(for: location)
                }
            })
            .store(in: &cancellables)
    }


    private func restartAndBindTimer() {
        let currentTimePublisher = Timer.TimerPublisher(interval: 60, runLoop: .main, mode: .default)
        timerCancellable?.cancel()
        timerCancellable = currentTimePublisher
            .autoconnect()
            .sink(receiveValue: { [weak self] value in
                if let location = self?.lastLocation {
                    self?.requestWeather(for: location)
                }
            })
    }

    private func handleLocationError(error: LocationError) {
        switch error {
        case .unknown:
            errorMessage = L10n.CurrentWeather.LocationError.message
        case .userDeclined:
            errorMessage = L10n.CurrentWeather.LocationDisabled.message
        }
        temperature = "-"
    }

    private func handleNewLocation(location: CLLocation?) {
        guard lastLocation != location else {
            return
        }
        lastLocation = location
        guard userSelectedLocation == nil,
              let requestLocation = lastLocation,
              requestLocation.isLonAndLatDifferent(than: lastSuccessfullyFetchedLocation) else { return }
        requestWeather(for: requestLocation)
    }

    private func requestWeather(for location: CLLocation) {
        let requestLocale = locale
        let unit = locale.measurementString
        currentTask?.cancel()
        currentTask = Task(operation: { [weak self] in
            guard let self = self else { return }
            var weatherResponse: WeatherResponse?
            do {
                weatherResponse = try await self.weatherService.fetchWeather(lat: location.coordinate.latitude,
                                                                             lon: location.coordinate.longitude,
                                                                             unit: unit)
            } catch {
                self.handleServiceError()
            }
            if Task.isCancelled {
                return
            }
            if weatherResponse != nil {
                self.lastSuccessfullyFetchedLocation = location
            }
            self.restartAndBindTimer()
            self.handleResponse(weatherResponse: weatherResponse, localeProvider: requestLocale)
        })
    }

    private func handleServiceError() {
        temperature = "-"
        errorMessage = L10n.CurrentWeather.NetworkError.message
    }

    private func handleResponse(weatherResponse: WeatherResponse?,
                                localeProvider: LocaleProvider) {
        guard let weatherResponse else { return }
        errorMessage = ""
        let value = weatherResponse.main?.temp
        let unit = localeProvider.temperatureUnit
        let measurement = Measurement(value: value ?? 0, unit: unit)
        temperature = measurementFormatter.string(from: measurement)
    }
}


extension CLLocation {
    func isLonAndLatDifferent(than other: CLLocation?) -> Bool {
        guard let other else { return true }
        let value = coordinate.latitude == other.coordinate.latitude && coordinate.longitude == other.coordinate.longitude
        return !value
    }
}
