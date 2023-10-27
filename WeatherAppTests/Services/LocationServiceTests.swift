//
//  LocationServiceTests.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Combine
import CoreLocation
import XCTest
@testable import WeatherApp

final class LocationServiceTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    func testLocationPublisher() {
        let locationPublisherStub = PassthroughSubject<CLLocation, Error>()
        let managerStub = CLLocationManagerRecordingStub(publisher: locationPublisherStub.eraseToAnyPublisher())
        let sut = LocationService(clLocationManager: managerStub)
        let inputData: [CLLocation] = [
            CLLocation(latitude: 30.3, longitude: 40.5),
            CLLocation(latitude: 30.1, longitude: 40.1),
            CLLocation(latitude: 30.3, longitude: 40.6)
        ]
        var results: [CLLocation?] = []
        sut
            .locationPublisher
            .sink(receiveCompletion: { completion in
                XCTFail("Unexpected completion")
            }, receiveValue: { value in
                results.append(value)
            })
            .store(in: &cancellables)
        sut.start()
        for data in inputData {
            locationPublisherStub.send(data)
        }
        XCTAssertEqual(results, inputData)
        XCTAssertEqual(managerStub.requestAuthorizationCallsCount, 1)
        XCTAssertEqual(managerStub.startUpdatingLocationCallsCount, 1)
    }

    func testLocationPublisherError() {
        let locationPublisherStub = PassthroughSubject<CLLocation, Error>()
        let managerStub = CLLocationManagerRecordingStub(publisher: locationPublisherStub.eraseToAnyPublisher())
        let sut = LocationService(clLocationManager: managerStub)
        let inputData: [CLLocation] = [
            CLLocation(latitude: 30.3, longitude: 40.5),
            CLLocation(latitude: 30.1, longitude: 40.1),
            CLLocation(latitude: 30.3, longitude: 40.6)
        ]
        var results: [CLLocation?] = []
        sut
            .locationPublisher
            .sink(receiveCompletion: { completion in
                XCTFail("Unexpected completion")
            }, receiveValue: { value in
                results.append(value)
            })
            .store(in: &cancellables)
        sut.start()
        for data in inputData {
            locationPublisherStub.send(data)
        }
        XCTAssertEqual(results, inputData)
        XCTAssertEqual(managerStub.requestAuthorizationCallsCount, 1)
        XCTAssertEqual(managerStub.startUpdatingLocationCallsCount, 1)
    }

}
