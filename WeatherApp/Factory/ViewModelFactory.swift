//
//  ViewModelFactory.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation

struct ViewModelFactory {

    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory = ServiceFactory()) {
        self.serviceFactory = serviceFactory
    }

    @MainActor func locationPickerViewModel() -> some LocationPickerViewModelProtocol {
        LocationPickerViewModel(service: serviceFactory.weatherService)
    }
}
