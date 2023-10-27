//
//  LocationPickerViewModel.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Combine

@MainActor
protocol LocationPickerViewModelProtocol: ObservableObject {
    var searchText: String { get set }
    var results: [GeoViewModelItem] { get }
    var errorMessage: String { get }
}

@MainActor
final class LocationPickerViewModel: LocationPickerViewModelProtocol {
    @Published var searchText: String = ""
    @Published var results: [GeoViewModelItem] = []
    @Published var errorMessage: String = ""

    private let service: WeatherServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(service: WeatherServiceProtocol) {
        self.service = service
        bindSearch()
    }
}

private extension LocationPickerViewModel {

    func bindSearch() {
        $searchText
            .sink(receiveValue: { [weak self] text in
                self?.search(text: text)
            })
            .store(in: &cancellables)
    }

    func search(text: String) {
        Task { [weak self] in
            do {
                let geoData = try await self?.service.fetchGeoLocation(query: text)
                self?.handleResponse(geoResponse: geoData)
            } catch {
                self?.handleNetworkError()
            }
        }
    }

    func handleNetworkError() {
        errorMessage = L10n.LocationPicker.NetworkError.message
    }

    func handleResponse(geoResponse: GeoResponse?) {
        guard let geoResponse else { return }
        errorMessage = ""
        results = geoResponse.compactMap { GeoViewModelItem(lat: $0.lat, lon: $0.lon, name: $0.name, country: $0.country) }
    }
}
