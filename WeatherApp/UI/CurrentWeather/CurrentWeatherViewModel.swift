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

    @Published var locationName: String = ""
    @Published var temperature: String = ""
    @Published var details: String = ""
    @Published var minMax: String = ""

    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol

    private var userSelectedLocation: CLLocation?
    private var cancellables: Set<AnyCancellable> = []

    init(locationService: LocationServiceProtocol,
         weatherService: WeatherServiceProtocol) {
        self.locationService = locationService
        self.weatherService = weatherService
        bind()
    }
}

private extension CurrentWeatherViewModel {

    private func bind() {
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

    private func handleError(error: Error) {

    }

    private func handleNewLocation(location: CLLocation?) {
        guard userSelectedLocation == nil else { return }

        Task.detached(operation: { [weak self] in
            let weatherResponse = try await self?.fetchWeather()
        })
    }

    private func fetchWeather() async throws -> WeatherResponse? {
        try await weatherService.fetchWeather()
    }

    private func handleResponse() {

    }

}
