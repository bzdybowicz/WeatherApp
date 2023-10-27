//
//  WeatherServiceMock.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

@testable import WeatherApp

enum WeatherServiceMockError: Error {
    case testSampleError
}

final class WeatherServiceMock: WeatherServiceProtocol {

    private (set) var recordedCalls: [(lat: Double, lon: Double, unit: String)] = []

    private let responses: [WeatherResponse]
    private var responseIterator = 0

    init(responses: [WeatherResponse]) {
        self.responses = responses
    }

    func fetchWeather(lat: Double, lon: Double, unit: String) async throws -> WeatherResponse {
        if responses.isEmpty {
            throw WeatherServiceMockError.testSampleError
        }
        if responseIterator == responses.count {
            responseIterator = 0
        }
        let returnValue = responses[responseIterator]
        responseIterator += 1
        return returnValue
    }

}
