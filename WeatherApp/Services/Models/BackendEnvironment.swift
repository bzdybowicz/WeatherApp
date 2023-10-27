//
//  Backend.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

enum BackendEnvironment {
    case production

    var baseUrlString: String {
        switch self {
        case .production:
            return "https://api.openweathermap.org/data/2.5/weather"
        }
    }

    var remoteUrl: URL {
        get throws {
            if let url = URL(string: baseUrlString) {
                return url
            } else {
                throw ServiceError.urlCreationFailure
            }
        }
    }
}
