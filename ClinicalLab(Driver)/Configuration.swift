//
//  Configuration.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 4/14/24.
//

import Foundation

struct Configuration {
    static let baseURL = "https://pclwebapi.azurewebsites.net/api/"
    struct Endpoint {
        static let login = "/User/UserLogin"
        static let getCustomer = "Customer/GetCustomer"
        static let updateCustomer = "Customer/UpdateCustomer"
        static let addCustomer = "Customer/AddCustomer"
        static let deleteCustomer = "Customer/DeleteCustomer"
        static let getVehicle = "vehicle/GetVehicle"
        static let updateVehicle = "vehicle/UpdateVehicle"
        static let addVehicle = "vehicle/AddVehicle"
        static let deleteVehicle = "vehicle/DeleteVehicle"
        static let getRouteDetail = "Route/GetRouteDetail"
        static let getRoute = "Route/GetRoute"
        static let editRoute = "Route/EditRoute"
        static let addRoute = "Route/AddRoute"
        static let deleteRoute = "Route/DeleteRoute"
        static let addDriver = "Driver/AddDriver"
        static let getDriver = "Driver/GetDriver"
        static let updateDriver = "Driver/UpdateDriver"
        static let deleteDriver = "Driver/DeleteDriver"
        static let getDriverLocation = "Driver/GetDriverLocation"
        static let driverLogin = "Driver/DriverLogin"
        static let driverSignUp = "Driver/DriverSignUp"
        static let addUpdateTransactionStatus = "Admin/AddUpdateTransactionStatus"
    }
}
