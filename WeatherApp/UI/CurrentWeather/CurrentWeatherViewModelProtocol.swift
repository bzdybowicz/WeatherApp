//
//  CurrentWeatherViewModelProtocol.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

@MainActor
protocol CurrentWeatherViewModelProtocol: ObservableObject {
    var locationName: String { get }
    var temperature: String { get }
    var details: String { get }
    var minMax: String { get }
}
