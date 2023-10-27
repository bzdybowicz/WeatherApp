//
//  GeoViewModelItem.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation

struct GeoViewModelItem: Identifiable {
    let id: UUID
    let lat: Double
    let lon: Double
    let name: String

    init?(id: UUID = UUID(), lat: Double?, lon: Double?, name: String?) {
        self.id = id
        guard let lat, let lon, let name else { return nil }
        self.lat = lat
        self.lon = lon
        self.name = name
    }
}
