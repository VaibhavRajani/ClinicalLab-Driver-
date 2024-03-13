//
//  RouteDetailViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation
import MapKit

class RouteViewModel: ObservableObject {
    @Published var routeDetails: [RouteDetailResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var driverLocation: DriverLocation?
    @Published var customerLocations: [CustomerLocation] = []
    @Published var selectedCustomer: Customer?
    @Published var isShowingMapForCustomer: Bool = false
    
    func selectCustomer(_ customer: Customer) {
        self.selectedCustomer = customer
        self.isShowingMapForCustomer = true
    }
    
    private let routeService = RouteService()
    func fetchRouteDetail(routeNo: Int) {
        routeService.getRouteDetails(routeNumber: routeNo) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let routeDetails):
                    print("Fetched route details: \(routeDetails)")
                    
                    self?.routeDetails = routeDetails
                    if let driverId = routeDetails.first?.route.driverId {
                        self?.fetchDriverLocation(driverId: driverId)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchDriverLocation(driverId: Int) {
        routeService.getDriverLocation(driverId: driverId) { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case.success(let location):
                    self?.driverLocation = location
                case.failure(let error):
                    print("Error fetching driver location: \(error)")
                }
            }
            
        }
    }
    
    func addCustomerLocation(_ customer: Customer) {
        if let lat = customer.cust_Lat, let log = customer.cust_Log {
            let customerLocation = CustomerLocation(
                id: customer.id, name: customer.customerName,
                address: customer.streetAddress,
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: log)
            )
            customerLocations.append(customerLocation)
        }
    }
    
    func updateLocalCustomerStatus(customerId: Int, newStatus: String, numberOfSpecimens: Int) {
        if let routeIndex = routeDetails.firstIndex(where: { detail in
            detail.customer.contains(where: { $0.id == customerId })
        }), let customerIndex = routeDetails[routeIndex].customer.firstIndex(where: { $0.id == customerId }) {
            routeDetails[routeIndex].customer[customerIndex].collectionStatus = newStatus
            routeDetails[routeIndex].customer[customerIndex].specimensCollected = numberOfSpecimens
        }
    }
    
    func updateCustomerStatus(selectedCustomer: Customer, collectionStatus: String, numberOfSpecimens: String, completion: @escaping () -> Void)  {
        let collectionStatusMapping: [String: Int] = [
            "Not Collected": 0,
            "Collected": 1,
            "Rescheduled": 2,
            "Missed": 3,
            "Closed": 4,
            "Arrived": 5,
            "Other": 6
        ]
        
        let statusInt = collectionStatusMapping[collectionStatus] ?? 0
               // Then, convert numberOfSpecimens to an integer
               let numberOfSpecimensInt = Int(numberOfSpecimens) ?? 0
            
            let customerId = selectedCustomer.customerId ?? 0
            let routeId = routeDetails.first?.route.routeNo ?? 0
            let updateBy = String(routeDetails.first?.route.driverId ?? 0)
        
        routeService.updateTransactionStatus(customerId: selectedCustomer.customerId ?? 0, numberOfSpecimens: numberOfSpecimensInt, routeId: routeDetails.first?.route.routeNo ?? 0, status: statusInt, updateBy: String(routeDetails.first?.route.driverId ?? 0)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseString):
                        if responseString == "Success" {
                            // Find the customer in routeDetails and update the status
                            if let index = self?.routeDetails.firstIndex(where: { $0.customer.contains(where: { $0.id == selectedCustomer.id }) }),
                               let customerIndex = self?.routeDetails[index].customer.firstIndex(where: { $0.id == selectedCustomer.id }) {
                                self?.routeDetails[index].customer[customerIndex].collectionStatus = collectionStatus
                                self?.routeDetails[index].customer[customerIndex].specimensCollected = numberOfSpecimensInt
                                
                                // Set the flag to false to trigger the navigation back
                                self?.updateLocalCustomerStatus(customerId: customerId, newStatus: collectionStatus, numberOfSpecimens: numberOfSpecimensInt)
                                
                                // Set the flag to false to navigate back to RoutesView
                                self?.isShowingMapForCustomer = false      
                                self?.objectWillChange.send()

                            }
                            completion()

                        } else {
                            self?.errorMessage = "Update failed with message: \(responseString)"

                        }
                        
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        completion()

                    }
                    completion()

                    
                }

            }
    }

}
