//
//  MeasurementFormatterProtocol.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation

protocol MeasurementFormatterProtocol {
    func string(from measurement: Measurement<Unit>) -> String
}

extension MeasurementFormatter: MeasurementFormatterProtocol {}
