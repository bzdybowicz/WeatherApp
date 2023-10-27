//
//  CurrentWeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Combine
import CoreLocation
@testable import WeatherApp
import XCTest

@MainActor
final class CurrentWeatherViewModelTests: XCTestCase {

    private var locationSubject: PassthroughSubject<CLLocation?, LocationError>!
    private var locationStub: LocationServiceProtocol!
    private var weatherStub: WeatherServiceProtocol!
    private var measurementFormatterStub: MeasurementFormatterProtocol!
    private var notificationCenter: NotificationCenter!
    private var sut: CurrentWeatherViewModel!

    override func setUp() {
        super.setUp()
        locationSubject = PassthroughSubject<CLLocation?, LocationError>()
        locationStub = LocationServiceRecordingStub(publisher: locationSubject.eraseToAnyPublisher())
        weatherStub = WeatherServiceRecordingStub(responses: [])
        measurementFormatterStub = MeasurementFormatterRecordingStub(returnValues: [])
        notificationCenter = NotificationCenter()
        sut = CurrentWeatherViewModel(locationService: locationStub,
                                          weatherService: weatherStub,
                                          measurementFormatter: measurementFormatterStub,
                                          notificationCenter: notificationCenter)

    }

    func testStartState() {
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssertEqual(sut.temperature, "")
        XCTAssertEqual(sut.titleText, "currentWeather.title".localized)
    }

}
