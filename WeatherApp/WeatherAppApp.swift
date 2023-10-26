//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 25/10/2023.
//

import CoreLocation
import SwiftUI

@main
struct WeatherAppApp: App {

    private let serviceFactory = ServiceFactory()

    var body: some Scene {
        WindowGroup {
            CurrentWeatherView(viewModel: CurrentWeatherViewModel(locationService: serviceFactory.locationService,
                                                                  weatherService: serviceFactory.weatherService,
                                                                  measurementFormatter: MeasurementFormatter.formatter))
        }
    }
}
