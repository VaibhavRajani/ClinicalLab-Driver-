//
//  MapView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/11/24.
//

//import Foundation
//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @StateObject var viewModel: RouteViewModel
//    @State var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    @State var trackingMode: MapUserTrackingMode = .follow // Default value is `.follow`
//
//
//    var body: some View {
//        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: viewModel.customerLocations) { location in
//            MapMarker(coordinate: location.coordinate, tint: .red)
//        }
//        .onAppear {
//            if let driverLocation = viewModel.driverLocation {
//                region = MKCoordinateRegion(
//                    center: driverLocation.coordinate,
//                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                )
//            }
//        }
//    }
//}
//
//// Provide a preview with a default MapViewModel if necessary
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(viewModel: RouteViewModel())
//    }
//}

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel: MapViewViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion)
            .onAppear {
                viewModel.loadDriverLocation()
            }
            Button("Get Directions", action: viewModel.openDirectionsInMaps)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
    }
}


//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @ObservedObject var viewModel: MapViewViewModel
//
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $viewModel.mapRegion, showsUserLocation: true, annotations: viewModel.annotations)
//            VStack {
//                Spacer()
//                Button("Get Directions", action: viewModel.openDirectionsInMaps)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//        }
//        .onAppear {
//            viewModel.loadDriverLocation()
//        }
//    }
//}
