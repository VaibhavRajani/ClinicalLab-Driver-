//
//  MapViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/13/24.
//

import Foundation
import MapKit
import CoreLocation

class MapViewViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapRegion: MKCoordinateRegion
    @Published var annotations: [IdentifiableAnnotation] = []
    @Published var routeLine: MKPolyline?
    
    private var locationManager: CLLocationManager?
    private let customerLocation: CLLocationCoordinate2D
    
    init(driverLocationService: RouteService, driverId: Int, customerLocation: CLLocationCoordinate2D) {
        self.driverLocationService = driverLocationService
        self.driverId = driverId
        self.customerLocation = customerLocation
        self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        loadDriverLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        let driverAnnotation = DriverAnnotation(coordinate: currentLocation.coordinate)
        let customerAnnotation = CustomerAnnotation(coordinate: self.customerLocation)
        
        DispatchQueue.main.async {
            self.annotations = [
                IdentifiableAnnotation(annotation: driverAnnotation),
                IdentifiableAnnotation(annotation: customerAnnotation)
            ]
            self.fetchRoute()
        }
    }
    
    func fetchRoute() {
        let driverLocation = annotations.first { $0.annotation is DriverAnnotation }?.annotation.coordinate ?? CLLocationCoordinate2D()
        let customerLocation = self.customerLocation
        
        let driverPlacemark = MKPlacemark(coordinate: driverLocation)
        let customerPlacemark = MKPlacemark(coordinate: customerLocation)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: driverPlacemark)
        request.destination = MKMapItem(placemark: customerPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let route = response?.routes.first else { return }
            self?.routeLine = route.polyline
            self?.updateRegionForLocations(route: route)
        }
    }
    
    func updateRegionForLocations(route: MKRoute) {
        self.mapRegion = MKCoordinateRegion(route.polyline.boundingMapRect)
    }
    private let driverLocationService: RouteService
    let driverId: Int
    
    
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
                    
                    //                    self?.updateRegionForLocations(route: Route.Type)
                    self?.fetchRoute()
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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


