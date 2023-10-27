//
//  LocationPickerView.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import SwiftUI

struct LocationPickerView<ViewModel: LocationPickerViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @Binding var selectedItem: GeoViewModelItem?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            ForEach(viewModel.results) { item in
                Text(item.displayName).onTapGesture {
                    selectedItem = item
                    dismiss()
                }
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}
