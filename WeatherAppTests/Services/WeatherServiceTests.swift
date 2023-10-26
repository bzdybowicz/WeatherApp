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

    private let response = WeatherResponse(coord: LocationResponse(lon: <#T##Double?#>, lat: <#T##Double?#>), main: <#T##WeatherMainResponse?#>)

    func testFetchWeatherError() async throws {
        let sessionMock = URLSessionMock(error: TestError.sample)
        let decoderMock = JSONDecoderMock(decoded: response)
        let sut = WeatherService(urlSession: sessionMock, environment: .production, decoder: decoderMock)
        do {
            _ = try await sut.fetchWeather()
            XCTFail("Unexpected success")
        } catch let error {
            XCTAssertEqual(error as? TestError, TestError.sample)
        }
        XCTAssertEqual(sessionMock.recordedRequest?.url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather")
        XCTAssertEqual(decoderMock.recordedData, nil)
    }

    func testFetchWeatherSucces() async throws {
        let sessionMock = URLSessionMock(data: try JSONEncoder().encode(response))
        let decoderMock = JSONDecoderMock(decoded: response)
        let sut = WeatherService(urlSession: sessionMock, environment: .production, decoder: decoderMock)
        var weatherResponse: WeatherResponse?
        do {
            weatherResponse = try await sut.fetchWeather()
        } catch let error {
            XCTFail("Unexpected error \(error)")
        }
        XCTAssertEqual(weatherResponse, response)
        XCTAssertEqual(sessionMock.recordedRequest?.url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather")
        XCTAssertEqual(decoderMock.recordedData, try JSONEncoder().encode(response))
    }

}
