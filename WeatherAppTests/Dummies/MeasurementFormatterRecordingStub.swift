//
//  MeasurementFormatterRecordingStub.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation
@testable import WeatherApp

final class MeasurementFormatterRecordingStub: MeasurementFormatterProtocol {

    private (set) var recordedMeasurements: [Measurement<Unit>] = []

    private let returnValues: [String]
    private var returnValueIterator = 0

    init(returnValues: [String]) {
        self.returnValues = returnValues
    }

    func string(from measurement: Measurement<Unit>) -> String {
        if returnValueIterator == returnValues.count {
            returnValueIterator = 0
        }
        let returnValue = returnValues[returnValueIterator]
        returnValueIterator += 1
        return returnValue
    }

}
