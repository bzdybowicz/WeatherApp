//
//  WeatherServiceRecordingStub.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

@testable import WeatherApp

enum WeatherServiceTestError: Error {
    case testSampleError
}

struct TestWeatherServiceInput: Equatable {
    let lat: Double
    let lon: Double
    let unit: String
}

final class WeatherServiceRecordingStub: WeatherServiceProtocol {

    private (set) var weatherResponseInput: TestWeatherServiceInput?
    private (set) var geoResponseInput: String?

    private let weatherResponse: WeatherResponse?
    private let geoResponse: GeoResponse?

    init(weatherResponse: WeatherResponse? = nil, geoLocationResponses: GeoResponse? = nil) {
        self.weatherResponse = weatherResponse
        self.geoResponse = geoLocationResponses
    }

    func fetchWeather(lat: Double, lon: Double, unit: String) async throws -> WeatherResponse {
        weatherResponseInput = TestWeatherServiceInput(lat: lat, lon: lon, unit: unit)
        guard let weatherResponse else {
            throw WeatherServiceTestError.testSampleError
        }
        return weatherResponse
    }

    func fetchGeoLocation(query: String) async throws -> GeoResponse {
        geoResponseInput = query
        guard let geoResponse else {
            throw WeatherServiceTestError.testSampleError
        }
        return geoResponse
    }

}
