//
//  LocationPickerView.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import SwiftUI

struct LocationPickerView<ViewModel: LocationPickerViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        List {
            ForEach(viewModel.results) { item in
                Text(item.name)
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}
