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

    private let publisher: AnyPublisher<CLLocation, Never>
    private var cancellables: Set<AnyCancellable> = []
    private let manager = CLLocationManager()

    init(publisher: AnyPublisher<CLLocation, Never>) {
        self.publisher = publisher
    }

    func requestWhenInUseAuthorization() {
        requestAuthorizationCallsCount += 1
    }

    func startUpdatingLocation() {
        startUpdatingLocationCallsCount += 1

        publisher
            .sink { [weak self] location in
                self?.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
            }
            .store(in: &cancellables)
    }
}
