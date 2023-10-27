//
//  ServiceFactory.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import CoreLocation
import Foundation

struct ServiceFactory {

    var locationService: LocationServiceProtocol {
        LocationService(clLocationManager: CLLocationManager())
    }

    var weatherService: WeatherServiceProtocol {
        WeatherService(urlSession: URLSession.shared, environment: .production, apiKeyStorage: ApiKeyStorage(), decoder: JSONDecoder())
    }

}
