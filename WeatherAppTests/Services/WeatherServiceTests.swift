//
//  WeatherServiceTests.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

@testable import WeatherApp
import XCTest

enum TestError: Error {
    case sample
}

final class WeatherServiceTests: XCTestCase {

    private lazy var response = WeatherResponse(coord: LocationResponse(lon: randomLongitude,
                                                                        lat: randomLatitude),
                                                                        main: WeatherMainResponse(temp: randomTemp))

    private let randomLongitude = Double.random(in: -180...180)
    private let randomLatitude = Double.random(in: -90...90)
    private let randomTemp = Double.random(in: -237.15...100)

    func testFetchWeatherError() async throws {
        let sessionMock = URLSessionMock(error: TestError.sample)
        let decoderMock = JSONDecoderMock(decoded: response)
        let sut = WeatherService(urlSession: sessionMock, environment: .production, decoder: decoderMock)
        do {
            _ = try await sut.fetchWeather(lat: 10, lon: 10, unit: "metric")
            XCTFail("Unexpected success")
        } catch let error {
            XCTAssertEqual(error as? TestError, TestError.sample)
        }
        XCTAssertEqual(sessionMock.recordedRequest?.url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?lat=10.0&lon=10.0&appId=6654cf8df59efce3c4f7638b8587a72e&units=metric")
        XCTAssertEqual(decoderMock.recordedData, nil)
    }

    func testFetchWeatherSucces() async throws {
        let sessionMock = URLSessionMock(data: try JSONEncoder().encode(response))
        let decoderMock = JSONDecoderMock(decoded: response)
        let sut = WeatherService(urlSession: sessionMock, environment: .production, decoder: decoderMock)
        var weatherResponse: WeatherResponse?
        do {
            weatherResponse = try await sut.fetchWeather(lat: 10, lon: 10, unit: "metric")
        } catch let error {
            XCTFail("Unexpected error \(error)")
        }
        XCTAssertEqual(weatherResponse, response)
        XCTAssertEqual(sessionMock.recordedRequest?.url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?lat=10.0&lon=10.0&appId=6654cf8df59efce3c4f7638b8587a72e&units=metric")
        XCTAssertEqual(decoderMock.recordedData, try JSONEncoder().encode(response))
    }

}
