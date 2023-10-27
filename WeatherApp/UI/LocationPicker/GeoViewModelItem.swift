//
//  GeoViewModelItem.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation
import CoreLocation

struct GeoViewModelItem: Identifiable {
    let id: UUID
    let lat: Double
    let lon: Double
    let name: String
    let country: String

    init?(id: UUID = UUID(), lat: Double?, lon: Double?, name: String?, country: String?) {
        self.id = id
        guard let lat, let lon, let name, let country else { return nil }
        self.lat = lat
        self.lon = lon
        self.name = name
        self.country = country
    }

    var displayName: String {
        name + " (" + country + ")"
    }

    var location: CLLocation {
        CLLocation(latitude: lat, longitude: lon)
    }
}
