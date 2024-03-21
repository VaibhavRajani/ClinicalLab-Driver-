//
//  MapViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/13/24.
//

import Foundation
import MapKit

class MapViewViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion
    @Published var annotations: [IdentifiableAnnotation] = []

    private let driverLocationService: RouteService
    let driverId: Int
    private let customerLocation: CLLocationCoordinate2D
    
    init(driverLocationService: RouteService, driverId: Int, customerLocation: CLLocationCoordinate2D) {
        self.driverLocationService = driverLocationService
        self.driverId = driverId
        self.customerLocation = customerLocation
        self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)
        loadDriverLocation()
    }
    
    func loadDriverLocation() {
        driverLocationService.getDriverLocation(driverId: driverId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let driverLocation):
                    let driverCoordinate = CLLocationCoordinate2D(latitude: driverLocation.lat, longitude: driverLocation.log)
                    let driverAnnotation = DriverAnnotation(coordinate: driverCoordinate)
                    
                    let customerAnnotation = CustomerAnnotation(coordinate: self?.customerLocation ?? CLLocationCoordinate2D())
                    
                    self?.annotations = [
                        IdentifiableAnnotation(annotation: driverAnnotation),
                        IdentifiableAnnotation(annotation: customerAnnotation)
                    ]
                    
                    self?.updateRegionForLocations()
                    self?.fetchRoute()

                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateRegionForLocations() {
            guard let routeLine = routeLine else { return }
            
            var mapRect = routeLine.boundingMapRect
            
            let annotationsToInclude = annotations.map { $0.annotation.coordinate }
            for coordinate in annotationsToInclude {
                let point = MKMapPoint(coordinate)
                let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
                mapRect = mapRect.union(rect)
            }
            
            let paddedRect = mapRect.insetBy(dx: -mapRect.size.width * 0.2, dy: -mapRect.size.height * 0.2)
            let region = MKCoordinateRegion(paddedRect)
            
            DispatchQueue.main.async {
                self.mapRegion = region
            }
        }
    
    private func regionThatFits(annotations: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0

        for coordinate in annotations {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2)
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.1,
            longitudeDelta: (maxLon - minLon) * 1.1) 
        
        return MKCoordinateRegion(center: center, span: span)
    }

    func openDirectionsInMaps() {
        let placemark = MKPlacemark(coordinate: customerLocation, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Customer Location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func fetchRoute() {
        let driverLocation = annotations.first { $0.annotation is DriverAnnotation }?.annotation.coordinate ?? CLLocationCoordinate2D()
        let customerLocation = self.customerLocation
        
        let driverPlacemark = MKPlacemark(coordinate: driverLocation)
        let customerPlacemark = MKPlacemark(coordinate: customerLocation)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: driverPlacemark)
        request.destination = MKMapItem(placemark: customerPlacemark)
        request.transportType = .automobile // or adjust according to your app
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let route = response?.routes.first else { return }
            self?.routeLine = route.polyline // Store the route line
            self?.updateRegionForLocations()
        }
    }
    
    @Published var routeLine: MKPolyline?
    
}

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class CustomerAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}


