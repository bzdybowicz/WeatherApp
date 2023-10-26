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

    // Storing api keys in source code is not secure. This is just convenience shortcut given the purpose of this app.
    var apiKey: String {
        "6654cf8df59efce3c4f7638b8587a72e"
    }
}
