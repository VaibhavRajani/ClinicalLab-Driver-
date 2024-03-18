//
//  MapView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/11/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel: MapViewViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.annotations) { item in
            MapAnnotation(coordinate: item.annotation.coordinate) {
                if item.annotation is DriverAnnotation {
                    Image(systemName: "car").foregroundColor(.blue)
                } else {
                    Image(systemName: "mappin.circle.fill").foregroundColor(.red)
                }
            }
        }
        .onAppear {
            viewModel.loadDriverLocation()
        }
        .ignoresSafeArea(edges: .top)
    }
}
