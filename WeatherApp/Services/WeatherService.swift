//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

enum ServiceError: Error {
    case urlCreationFailure
    case requestFailure
}

protocol WeatherServiceProtocol {
    func fetchWeather(lat: Double,
                      lon: Double,
                      unit: String) async throws -> WeatherResponse
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

    func fetchWeather(lat: Double,
                      lon: Double,
                      unit: String) async throws -> WeatherResponse {
        var urlComponents = URLComponents(string: environment.baseUrlString)
        urlComponents?.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                     URLQueryItem(name: "lon", value: String(lon)),
                                     URLQueryItem(name: "appId", value: String(environment.apiKey)),
                                     URLQueryItem(name: "units", value: unit)]
        guard let url = urlComponents?.url else { throw ServiceError.urlCreationFailure }
        let urlRequest = URLRequest(url: url)
        let response = try await urlSession.data(for: urlRequest)
        return try decoder.decode(WeatherResponse.self, from: response.0)
    }
}
