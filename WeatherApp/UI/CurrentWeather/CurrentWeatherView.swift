//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 26/10/2023.
//

import SwiftUI

struct CurrentWeatherView<ViewModel: CurrentWeatherViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    let viewModelFactory: ViewModelFactory

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NavigationLink(destination: LocationPickerView(viewModel: viewModelFactory.locationPickerViewModel())) {
                    Text("Select location")
                }
                Spacer()
                    .frame(height: 100)
                Text(viewModel.titleText).font(.title)
                Spacer().frame(height: 10)
                Text(viewModel.temperature).font(.largeTitle)
                Spacer().frame(height: 24)
                Text(viewModel.errorMessage)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
            }
            .alert(viewModel.apiAlertTitle, isPresented: $viewModel.isAlertPresented) {
                TextField(viewModel.apiAlertTitle, text: $viewModel.apiKey)
                Button(viewModel.apiAlertOk, action: {
                    viewModel.isAlertPresented.toggle()
                    viewModel.apiKeyUpdatedAction()
                })
            } message: {
                Text(viewModel.apiAlertDescription)
            }
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
        }
    }

}
