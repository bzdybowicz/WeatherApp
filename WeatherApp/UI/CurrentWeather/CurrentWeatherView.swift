//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import SwiftUI

struct CurrentWeatherView<ViewModel: CurrentWeatherViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .center) {
            Text(viewModel.titleText).font(.title)
            Spacer().frame(height: 10)
            Text(viewModel.temperature).font(.largeTitle)
            Spacer().frame(height: 24)
            Text(viewModel.errorMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
    }
}
