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
    var selectLocationButtonText: String { get }

    var apiAlertTitle: String { get }
    var apiAlertDescription: String { get }
    var apiAlertOk: String { get }

    var isAlertPresented: Bool { get set }
    var apiKey: String { get set }
    var deleteKeyButtonText: String { get }

    var selectedGeoItem: GeoViewModelItem? { get set }

    func apiKeyUpdatedAction()
    func deleteApiKey()
}
