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
        .overlay(MapOverlay(polyline: viewModel.routeLine))
        .onAppear {
            viewModel.loadDriverLocation()
        }
        .ignoresSafeArea(edges: .top)
        
        Button("Get Directions", action: viewModel.openDirectionsInMaps)
                        .padding()
                        .cornerRadius(8)
    }
}

struct MapOverlay: View {
    var polyline: MKPolyline?
    
    var body: some View {
        MapPolyline(polyline: polyline, lineColor: .blue)
    }
}

struct MapPolyline: UIViewRepresentable {
    let polyline: MKPolyline?
    let lineColor: UIColor
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard let polyline = polyline else { return }
        uiView.addOverlay(polyline)
        uiView.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapPolyline
        
        init(_ parent: MapPolyline) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = parent.lineColor
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

