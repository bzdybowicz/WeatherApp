//
//  CurrentWeatherViewModelProtocol.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import Foundation

@MainActor
protocol CurrentWeatherViewModelProtocol: ObservableObject {
    var titleText: String { get }
    var temperature: String { get }
    var errorMessage: String { get }
}
