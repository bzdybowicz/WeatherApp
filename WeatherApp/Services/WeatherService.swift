//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

enum ServiceError: Error {
    case invalidUrl
    case requestFailure
}

protocol WeatherServiceProtocol {
    func fetchWeather() async throws -> WeatherResponse
}

struct WeatherService: WeatherServiceProtocol {

    private let urlSession: URLSessionProtocol
    private let environment: BackendEnvironment
    private let decoder: JSONDecoderProtocol

    init(urlSession: URLSessionProtocol,
         environment: BackendEnvironment,
         decoder: JSONDecoderProtocol) {
        self.urlSession = urlSession
        self.environment = environment
        self.decoder = decoder
    }

    func fetchWeather() async throws -> WeatherResponse {
        let urlRequest = URLRequest(url: try environment.remoteUrl)
        let response = try await urlSession.data(for: urlRequest)
        return try decoder.decode(WeatherResponse.self, from: response.0)
    }
}
