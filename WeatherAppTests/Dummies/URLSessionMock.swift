//
//  URLSessionMock.swift
//  WeatherAppTests
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation
@testable import WeatherApp

final class URLSessionMock: URLSessionProtocol {

    private let data: Data?
    private let urlResponse: URLResponse?
    private let error: Error?

    private(set) var recordedRequest: URLRequest?

    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.recordedRequest = request
        if let error = error {
            throw error
        }
        return (data ?? Data(), urlResponse ?? URLResponse())
    }
}
