//
//  LocationService.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Combine
import CoreLocation

enum LocationError: Error {
    case unknown
    case userDeclined
}

protocol LocationServiceProtocol {
    var locationPublisher: AnyPublisher<CLLocation?, Error> { get }

    func start()
}

final class LocationService: NSObject, LocationServiceProtocol {
    var locationPublisher: AnyPublisher<CLLocation?, Error> {
        locationSubject.eraseToAnyPublisher()
    }

    private let locationSubject = PassthroughSubject<CLLocation?, Error>()
    private var clLocationManager: CLLocationManagerProtocol

    init(clLocationManager: CLLocationManagerProtocol) {
        self.clLocationManager = clLocationManager
        super.init()
        setup()
    }

    func start() {
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationSubject.send(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied, .promptDeclined:
                locationSubject.send(completion: .failure(LocationError.userDeclined))
            default:
                locationSubject.send(nil)
            }
        } else {
            locationSubject.send(completion: .failure(LocationError.unknown))
        }
    }
}

private extension LocationService {
    private func setup() {
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.delegate = self
    }
}
