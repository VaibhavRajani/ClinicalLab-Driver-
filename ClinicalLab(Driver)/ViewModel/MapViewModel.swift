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
    @Published var annotations: [MKAnnotation] = []

    private let driverLocationService: RouteService
    let driverId: Int
    private let customerLocation: CLLocationCoordinate2D

    init(driverLocationService: RouteService, driverId: Int, customerLocation: CLLocationCoordinate2D) {
        self.driverLocationService = driverLocationService
        self.driverId = driverId
        self.customerLocation = customerLocation
        self.mapRegion = MKCoordinateRegion(center: customerLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }

    func loadDriverLocation() {
        driverLocationService.getDriverLocation(driverId: driverId) { [weak self] result in
            switch result {
            case .success(let driverLocation):
                    DispatchQueue.main.async {
                        self?.annotations.append(DriverAnnotation(coordinate: CLLocationCoordinate2D(latitude: driverLocation.lat, longitude: driverLocation.log)))
                        self?.annotations.append(CustomerAnnotation(coordinate: self?.customerLocation ?? CLLocationCoordinate2D()))
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
