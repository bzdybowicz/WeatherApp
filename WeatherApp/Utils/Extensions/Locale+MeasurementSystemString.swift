//
//  Locale+MeasurementSystemString.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

extension Locale {
    var measurementString: String {
        switch measurementSystem {
        case .metric:
            return "metric"
        case .uk:
            return "imperial"
        case .us:
            return "imperial"
        default:
            return "standard"
        }
    }

    var temperatureUnit: Unit {
        switch measurementSystem {
        case .metric:
            return UnitTemperature.celsius
        case .uk:
            return UnitTemperature.fahrenheit
        case .us:
            return UnitTemperature.fahrenheit
        default:
            return UnitTemperature.kelvin
        }
    }
}
