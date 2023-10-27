//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 25/10/2023.
//

import CoreLocation
import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            WeatherAppApp.main()
        } else {
            WeatherAppUnits.main()
        }
    }
}

struct WeatherAppUnits: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}


struct WeatherAppApp: App {

    private let serviceFactory = ServiceFactory()
    private let viewModelFactory: ViewModelFactory

    init() {
        self.viewModelFactory = ViewModelFactory(serviceFactory: serviceFactory)
    }

    var body: some Scene {
        WindowGroup {
            CurrentWeatherView(viewModel: CurrentWeatherViewModel(locationService: serviceFactory.locationService,
                                                                  weatherService: serviceFactory.weatherService,
                                                                  measurementFormatter: MeasurementFormatter.formatter,
                                                                  apiKeyStorage: ApiKeyStorage()),
                               viewModelFactory: viewModelFactory)
        }
    }
}
