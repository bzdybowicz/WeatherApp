//
//  CLLocationManagerProtocol.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import CoreLocation

protocol CLLocationManagerProtocol {
    func requestWhenInUseAuthorization()
    func startMonitoringSignificantLocationChanges()

    var desiredAccuracy: CLLocationAccuracy { get set }
    var delegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: CLLocationManagerProtocol {}
