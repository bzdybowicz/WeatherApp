//
//  LocationServiceRecordingStub.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Combine
import CoreLocation
@testable import WeatherApp

final class LocationServiceRecordingStub: LocationServiceProtocol {

    let locationPublisher: AnyPublisher<CLLocation?, LocationError>

    private (set) var startCallsCount: Int = 0

    func start() {
        startCallsCount += 1
    }

    init(publisher: AnyPublisher<CLLocation?, LocationError>) {
        self.locationPublisher = publisher
    }

}
