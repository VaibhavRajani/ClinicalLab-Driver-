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
                    Text(selectedCustomer.customerName ?? "Unknown")
                        .font(.title2)
                    Text("\(selectedCustomer.streetAddress ?? ""), \(selectedCustomer.city ?? ""), \(selectedCustomer.state ?? "")")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
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
                        Text("Number of Specimens Collected:")
                        TextField("\(selectedCustomer.specimensCollected ?? 0)", text: $numberOfSpecimens)
                            .keyboardType(.numberPad)
                            .frame(width: 50)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    
                    Button("Update") {
                        viewModel.updateCustomerStatus(selectedCustomer: selectedCustomer, collectionStatus: specimenStatusOptions[selectedSpecimenStatusIndex], numberOfSpecimens: numberOfSpecimens){
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
                Text("Loading customer details...")
            }
        }
        .toolbarBackground(
            Color.customPink,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("", displayMode: .inline)
    }
}
