//
//  Driver.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/4/24.
//

import Foundation
import CoreLocation

struct DriverLocation: Codable {
    let lat: Double
    let log: Double
    let geofence: Bool
    
    enum CodingKeys: String, CodingKey {
        case lat = "Lat"
        case log = "Log"
        case geofence = "Geofence"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: log)
    }
}

struct CustomerLocation: Identifiable {
    let id: Customer.ID
    let name: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
}
