//
//  LocationService.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Combine
import CoreLocation

protocol LocationServiceProtocol {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }

    func start()
}

final class LocationService: NSObject, LocationServiceProtocol {
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }

    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private var clLocationManager: CLLocationManagerProtocol

    init(clLocationManager: CLLocationManagerProtocol) {
        self.clLocationManager = clLocationManager
        super.init()
        setup()
    }

    func start() {
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationSubject.send(location)
    }
}

private extension LocationService {
    private func setup() {
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.delegate = self
    }
}
