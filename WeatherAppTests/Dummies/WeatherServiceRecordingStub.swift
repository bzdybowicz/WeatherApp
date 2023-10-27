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
    let apiKey: String
    let unit: String
}

final class WeatherServiceRecordingStub: WeatherServiceProtocol {

    private (set) var recordedCalls: [TestWeatherServiceInput] = []

    private let responses: [WeatherResponse]
    private var responseIterator = 0

    init(responses: [WeatherResponse]) {
        self.responses = responses
    }

    func fetchWeather(lat: Double, lon: Double, apiKey: String, unit: String) async throws -> WeatherResponse {
        recordedCalls.append(TestWeatherServiceInput(lat: lat, lon: lon, apiKey: apiKey, unit: unit))
        if responses.isEmpty {
            throw WeatherServiceTestError.testSampleError
        }
        if responseIterator == responses.count {
            responseIterator = 0
        }
        let returnValue = responses[responseIterator]
        responseIterator += 1
        return returnValue
    }

}
