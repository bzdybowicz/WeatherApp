//
//  MeasurementFormatter+Instance.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

extension MeasurementFormatter {
    static let formatter: MeasurementFormatter = {
        let instance = MeasurementFormatter()
        instance.unitOptions = .providedUnit
        return instance
    }()
}
