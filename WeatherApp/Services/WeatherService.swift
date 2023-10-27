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
    case noApiKey
}

protocol WeatherServiceProtocol {
    func fetchWeather(lat: Double,
                      lon: Double,
                      unit: String) async throws -> WeatherResponse

    func fetchGeoLocation(query: String) async throws -> GeoResponse
}

struct WeatherService: WeatherServiceProtocol {

    private let urlSession: URLSessionProtocol
    private let environment: BackendEnvironment
    private let apiKeyStorage: ApiKeyStorageProtocol
    private let decoder: JSONDecoderProtocol
    

    init(urlSession: URLSessionProtocol,
         environment: BackendEnvironment,
         apiKeyStorage: ApiKeyStorageProtocol,
         decoder: JSONDecoderProtocol) {
        self.urlSession = urlSession
        self.environment = environment
        self.apiKeyStorage = apiKeyStorage
        self.decoder = decoder
    }

    func fetchWeather(lat: Double,
                      lon: Double,
                      unit: String) async throws -> WeatherResponse {
        var urlComponents = URLComponents(string: environment.weatherUrlString)
        guard let key = try? apiKeyStorage.getKey() else {
            throw ServiceError.noApiKey
        }
        urlComponents?.queryItems = [URLQueryItem(name: "lat", value: String(lat)),
                                     URLQueryItem(name: "lon", value: String(lon)),
                                     URLQueryItem(name: "appId", value: key),
                                     URLQueryItem(name: "units", value: unit)]
        guard let url = urlComponents?.url else { throw ServiceError.urlCreationFailure }
        let urlRequest = URLRequest(url: url)
        let response = try await urlSession.data(for: urlRequest)
        return try decoder.decode(WeatherResponse.self, from: response.0)
    }

    func fetchGeoLocation(query: String) async throws -> GeoResponse {
        var urlComponents = URLComponents(string: environment.geoUrlString)
        guard let key = try? apiKeyStorage.getKey() else {
            throw ServiceError.noApiKey
        }
        urlComponents?.queryItems = [URLQueryItem(name: "q", value: "{\(query)}"),
                                     URLQueryItem(name: "limit", value: "5"),
                                     URLQueryItem(name: "appId", value: key),]
        guard let url = urlComponents?.url else { throw ServiceError.urlCreationFailure }
        let urlRequest = URLRequest(url: url)
        let response = try await urlSession.data(for: urlRequest)
        let string = String(data: response.0, encoding: .utf8)
        //print("STRING \(string)")
        return try decoder.decode(GeoResponse.self, from: response.0)
    }
}
