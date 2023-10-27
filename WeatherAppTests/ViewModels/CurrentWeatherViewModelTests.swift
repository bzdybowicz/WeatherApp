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

final class CurrentWeatherViewModelTests: XCTestCase {

    @MainActor func test() {
        let locationSubject = PassthroughSubject<CLLocation?, LocationError>()
        let locationMock = LocationServiceMock(publisher: locationSubject.eraseToAnyPublisher())
        let weatherMock = WeatherServiceMock(responses: [])
        let measurementFormatterMock = MeasurementFormatterMock(returnValues: [])
        let sut = CurrentWeatherViewModel(locationService: locationMock,
                                          weatherService: weatherMock,
                                          measurementFormatter: measurementFormatterMock)
    }

}
