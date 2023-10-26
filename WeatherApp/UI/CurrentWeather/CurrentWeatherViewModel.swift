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

    @Published var titleText: String = "currentWeather.title".localized
    @Published var temperature: String = ""

    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private let measurementFormatter: MeasurementFormatter
    private let locale: LocaleProvider
    private let notificationCenter: NotificationCenter

    private var lastLocation: CLLocation?
    private var lastSuccessfullyFetchedLocation: CLLocation?
    private var userSelectedLocation: CLLocation?
    private var currentTask: Task<(), Error>?
    private var cancellables: Set<AnyCancellable> = []
    private var timerCancellable: Cancellable?

    init(locationService: LocationServiceProtocol,
         weatherService: WeatherServiceProtocol,
         measurementFormatter: MeasurementFormatter,
         notificationCenter: NotificationCenter = .default,
         locale: LocaleProvider = Locale.autoupdatingCurrent) {
        self.locationService = locationService
        self.weatherService = weatherService
        self.measurementFormatter = measurementFormatter
        self.notificationCenter = notificationCenter
        self.locale = locale
        bindLocation()
        bindLocale()
        restartAndBindTimer()
    }
}

private extension CurrentWeatherViewModel {

    private func bindLocation() {
        locationService
            .locationPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error: error)
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

    private func handleError(error: Error) {

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
            let weatherResponse = try await self?.weatherService.fetchWeather(lat: location.coordinate.latitude,
                                                                              lon: location.coordinate.longitude,
                                                                              unit: unit)
            if Task.isCancelled {
                return
            }
            if weatherResponse != nil {
                self?.lastSuccessfullyFetchedLocation = location
            }
            self?.restartAndBindTimer()
            self?.handleResponse(weatherResponse: weatherResponse, localeProvider: requestLocale)
        })
    }

    private func handleResponse(weatherResponse: WeatherResponse?,
                                localeProvider: LocaleProvider) {
        guard let weatherResponse else { return }

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
