//
//  Backend.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

enum BackendEnvironment {
    case production

    var weatherUrlString: String {
        switch self {
        case .production:
            return "https://api.openweathermap.org/data/2.5/weather"
        }
    }

    var geoUrlString: String {
        switch self {
        case .production:
            return "https://api.openweathermap.org/geo/1.0/direct"
        }
    }
}
