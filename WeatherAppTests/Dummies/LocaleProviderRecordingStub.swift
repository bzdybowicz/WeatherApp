//
//  LocaleProviderRecordingStub.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation
@testable import WeatherApp

final class LocaleProviderRecordingStub: LocaleProvider {

    var measurementSystem: Locale.MeasurementSystem
    var measurementString: String
    var temperatureUnit: Unit

    init(measurementSystem: Locale.MeasurementSystem, measurementString: String, temperatureUnit: Unit) {
        self.measurementSystem = measurementSystem
        self.measurementString = measurementString
        self.temperatureUnit = temperatureUnit
    }

    func update(measurementSystem: Locale.MeasurementSystem? = nil,
                measurementString: String? = nil,
                temperatureUnit: Unit? = nil) {
        self.measurementSystem = measurementSystem ?? self.measurementSystem
        self.measurementString = measurementString ?? self.measurementString
        self.temperatureUnit = temperatureUnit ?? self.temperatureUnit
    }
}
