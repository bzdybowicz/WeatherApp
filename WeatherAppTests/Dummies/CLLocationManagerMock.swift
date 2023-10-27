//
//  CLLocationManagerMock.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Combine
import CoreLocation
@testable import WeatherApp

final class CLLocationManagerMock: CLLocationManagerProtocol {

    private (set) var requestAuthorizationCallsCount: Int = 0
    private (set) var startUpdatingLocationCallsCount: Int = 0

    var desiredAccuracy: CLLocationAccuracy = 0.0
    var delegate: CLLocationManagerDelegate?

    private let publisher: AnyPublisher<CLLocation, Error>
    private var cancellables: Set<AnyCancellable> = []
    private let manager = CLLocationManager()

    init(publisher: AnyPublisher<CLLocation, Error>) {
        self.publisher = publisher
    }

    func requestWhenInUseAuthorization() {
        requestAuthorizationCallsCount += 1
    }

    func startMonitoringSignificantLocationChanges() {
        startUpdatingLocationCallsCount += 1

        publisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] location in
                self?.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
            })
            .store(in: &cancellables)
    }

}
