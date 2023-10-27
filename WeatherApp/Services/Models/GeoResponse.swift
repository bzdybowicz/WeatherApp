//
//  GeoResponse.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation

typealias GeoResponse = [GeoResponseItem]

struct GeoResponseItem: Codable, Equatable {
    let lat: Double?
    let lon: Double?
    let name: String?
}
