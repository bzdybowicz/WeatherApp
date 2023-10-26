//
//  LocaleProvider.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

protocol LocaleProvider {
    var measurementSystem: Locale.MeasurementSystem { get }
    var measurementString: String { get }
    var temperatureUnit: Unit { get }
}

extension Locale: LocaleProvider {
}
