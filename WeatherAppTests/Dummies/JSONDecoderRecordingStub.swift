//
//  JSONDecoderRecordingStub.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation
@testable import WeatherApp
import XCTest

final class JSONDecoderRecordingStub: JSONDecoderProtocol {

    private let decoded: Decodable

    private(set) var recordedData: Data?

    init(decoded: Decodable) {
        self.decoded = decoded
    }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        recordedData = data
        return try XCTUnwrap(decoded as? T)
    }
}
