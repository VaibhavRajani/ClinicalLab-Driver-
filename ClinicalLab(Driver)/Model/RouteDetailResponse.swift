//
//  Route.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

struct RouteDetailResponse: Codable {
    var route: Route
    var customer: [Customer]
    enum CodingKeys: String, CodingKey {
        case route = "Route"
        case customer = "Customer"
    }}

struct Route: Codable {
    var routeNo: Int?
    var routeName: String?
    var driverId: Int?
    var driverName: String?
    var vehicleNo: String?
    var vehicleId: Int?

    enum CodingKeys: String, CodingKey {
        case routeNo = "RouteNo"
        case routeName = "RouteName"
        case driverId = "DriverId"
        case driverName = "DriverName"
        case vehicleNo = "VehicleNo"
        case vehicleId = "VehicleId"
    }
}

struct Customer: Codable, Identifiable, Equatable {
    var id: Int { customerId ?? 0 }
    let customerId: Int?
    let customerName: String?
    let streetAddress: String?
    var city: String?
    let state: String?
    let zip: String?
    var specimensCollected: Int?
    let pickUpTime: String?
    var collectionStatus: String?
    let isSelected: Bool?
    let cust_Lat: Double?
    let cust_Log: Double?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "CustomerId"
        case customerName = "CustomerName"
        case streetAddress = "StreetAddress"
        case city = "City"
        case state = "State"
        case zip = "Zip"
        case specimensCollected = "SpecimensCollected"
        case pickUpTime = "PickUpTime"
        case collectionStatus = "CollectionStatus"
        case isSelected = "IsSelected"
        case cust_Lat = "Cust_Lat"
        case cust_Log = "Cust_Log"
    }
}
