//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

struct WeatherResponse: Codable, Equatable {
    let coord: LocationResponse?
    let main: WeatherMainResponse?
}

struct LocationResponse: Codable, Equatable {
    let lon: Double?
    let lat: Double?
}

struct WeatherMainResponse: Codable, Equatable {
    let temp: Double?
}
