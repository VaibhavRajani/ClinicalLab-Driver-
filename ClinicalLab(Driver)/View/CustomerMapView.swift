//
//  CustomerMapView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 3/13/24.
//

import Foundation
import SwiftUI
import MapKit

struct CustomerMapView: View {
    @ObservedObject var viewModel: RouteViewModel
    private let specimenStatusOptions = ["Not Collected", "Collected", "Rescheduled", "Missed", "Closed", "Arrived", "Other"]
    @State private var selectedSpecimenStatusIndex = 0
    @State private var numberOfSpecimens: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let selectedCustomer = viewModel.selectedCustomer, let driverLocation = viewModel.driverLocation {
                VStack {
                    // Customer Name and Address
                    Text(selectedCustomer.customerName ?? "Unknown")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(selectedCustomer.streetAddress ?? ""), \(selectedCustomer.city ?? ""), \(selectedCustomer.state ?? "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Map View
                    MapView(viewModel: MapViewViewModel(driverLocationService: RouteService(), driverId: viewModel.routeDetails.first?.route.driverId ?? 87, customerLocation: CLLocationCoordinate2D(latitude: selectedCustomer.cust_Lat ?? 0, longitude: selectedCustomer.cust_Log ?? 0)))
                    
                    HStack{
                        Text("Specimen Status: ")
                        Picker("Specimen Status", selection: $selectedSpecimenStatusIndex) {
                            ForEach(0..<specimenStatusOptions.count, id: \.self) {
                                Text(self.specimenStatusOptions[$0])
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                    }
                    
                    HStack{
                        Text("Number of Speciment Collected:")
                        TextField("", text: $numberOfSpecimens)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    
                    Button("Update") {
                        // Assuming viewModel.updateCustomerStatus handles the API call and updates internally
                        viewModel.updateCustomerStatus(selectedCustomer: selectedCustomer, collectionStatus: specimenStatusOptions[selectedSpecimenStatusIndex], numberOfSpecimens: numberOfSpecimens){
                            // After the update is complete, fetch the latest route details
                            viewModel.fetchRouteDetail(routeNo: viewModel.routeDetails.first?.route.routeNo ?? 87)
                            self.presentationMode.wrappedValue.dismiss()

                        }
                        
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                }
                .padding()
            } else {
                // Show a loading or error message if needed
                Text("Loading customer details...")
            }
        }
        .navigationBarTitle("Customer Details", displayMode: .inline)
    }
}
