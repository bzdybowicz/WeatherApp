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
    private var locationStub: LocationServiceRecordingStub!
    private var weatherStub: WeatherServiceRecordingStub!
    private var measurementFormatterStub: MeasurementFormatterProtocol!
    private var notificationCenter: NotificationCenter!
    private var apiKeyStub: ApiKeyStorageProtocol!
    private var localeProvider: LocaleProviderRecordingStub!
    private var sut: CurrentWeatherViewModel!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        cancellables.forEach { $0.cancel() }
        locationSubject = PassthroughSubject<CLLocation?, LocationError>()
        locationStub = LocationServiceRecordingStub(publisher: locationSubject.eraseToAnyPublisher())
        weatherStub = WeatherServiceRecordingStub(weatherResponse: WeatherResponse(coord: LocationResponse(lon: 10, lat: 10),
                                                                                   main: WeatherMainResponse(temp: 13))
        )
        measurementFormatterStub = MeasurementFormatterRecordingStub(returnValues: ["10", "20"])
        notificationCenter = NotificationCenter()
        apiKeyStub = ApiKeyStorageRecordingStub(key: "Key")
        localeProvider = LocaleProviderRecordingStub(measurementSystem: [.metric, .us, .uk].randomElement()!,
                                                     measurementString: "InputUnit",
                                                     temperatureUnit: Unit(symbol: "UNIT"))
        sut = CurrentWeatherViewModel(locationService: locationStub,
                                      weatherService: weatherStub,
                                      measurementFormatter: measurementFormatterStub,
                                      apiKeyStorage: apiKeyStub,
                                      notificationCenter: notificationCenter,
                                      locale: localeProvider)
    }

    func testStartState() {
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssertEqual(sut.temperature, "")
        XCTAssertEqual(sut.titleText, L10n.CurrentWeather.title)
        XCTAssertEqual(sut.apiAlertOk, L10n.CurrentWeather.KeyAlert.confirmText)
        XCTAssertEqual(sut.apiAlertTitle, L10n.CurrentWeather.KeyAlert.title)
        XCTAssertEqual(sut.apiAlertDescription, L10n.CurrentWeather.KeyAlert.description)
        XCTAssertEqual(sut.isAlertPresented, false)
        XCTAssertEqual(sut.apiKey, "Key")
    }

    func testStartStateApiKeyEmpty() {
        apiKeyStub = ApiKeyStorageRecordingStub(key: nil)
        sut = CurrentWeatherViewModel(locationService: locationStub,
                                      weatherService: weatherStub,
                                      measurementFormatter: measurementFormatterStub,
                                      apiKeyStorage: apiKeyStub,
                                      notificationCenter: notificationCenter)
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssertEqual(sut.temperature, "")
        XCTAssertEqual(sut.titleText, L10n.CurrentWeather.title)
        XCTAssertEqual(sut.apiAlertOk, L10n.CurrentWeather.KeyAlert.confirmText)
        XCTAssertEqual(sut.apiAlertTitle, L10n.CurrentWeather.KeyAlert.title)
        XCTAssertEqual(sut.apiAlertDescription, L10n.CurrentWeather.KeyAlert.description)
        XCTAssertEqual(sut.isAlertPresented, true)
        XCTAssertEqual(sut.apiKey, "")
    }

    func testTemperature() async {
        locationSubject.send(CLLocation(latitude: 30.3, longitude: 40.5))
        let expectation = expectation(description: "Api calls are triggered")
        var values: [String] = []
        sut
            .$temperature
            .sink { value in
                values.append(value)
                // Initial published var value + the one from stub. Sending more is problematic due to task cancellation.
                if values.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(weatherStub.weatherResponseInput, TestWeatherServiceInput(lat: 30.3, lon: 40.5, unit: "InputUnit"))
    }

    func testNetworkError() async {
        let weatherServiceStub = WeatherServiceRecordingStub()
        sut = CurrentWeatherViewModel(locationService: locationStub,
                                      weatherService: weatherServiceStub,
                                      measurementFormatter: measurementFormatterStub,
                                      apiKeyStorage: apiKeyStub,
                                      notificationCenter: notificationCenter,
                                      locale: localeProvider)
        locationSubject.send(CLLocation(latitude: 30.3, longitude: 40.5))
        let expectation = expectation(description: "Api calls are triggered")
        var values: [String] = []
        sut
            .$errorMessage
            .sink { value in
                values.append(value)
                if values.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(values, ["", L10n.CurrentWeather.NetworkError.message])
    }

    func testLocationError() async {
        let expectation = expectation(description: "Api calls are triggered")
        var values: [String] = []
        sut
            .$errorMessage
            .sink { value in
                values.append(value)
                if values.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        locationSubject.send(completion: .failure(LocationError.unknown))
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(values, ["", L10n.CurrentWeather.LocationError.message])
    }

    func testLocationDisabledError() async {
        let expectation = expectation(description: "Api calls are triggered")
        var values: [String] = []
        sut
            .$errorMessage
            .sink { value in
                values.append(value)
                if values.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        locationSubject.send(completion: .failure(LocationError.userDeclined))
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(values, ["", L10n.CurrentWeather.LocationDisabled.message])
    }

}
