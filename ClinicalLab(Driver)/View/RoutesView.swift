//
//  RoutesView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation
import SwiftUI
import MapKit

struct RoutesView: View {
    @StateObject var viewModel: RouteViewModel
    let routeNo: Int
    @State private var showingSettings = false // State to control the presentation of SettingsView

    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.routeDetails.isEmpty {
                    Text("Fetching route details...")
                } else {
                    ForEach(viewModel.routeDetails, id: \.route.routeNo) { routeDetail in
                        
                        routeInformationView(routeDetail: routeDetail)
                        customerListView(customers: routeDetail.customer)
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Routes") // Set the title for your navigation bar here
                        .navigationBarItems(trailing: Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gear") // Use any icon that suits your design
                        })
                        .sheet(isPresented: $showingSettings) {
                            SettingsView() // Your settings view here
                        }
            .onAppear {
                DispatchQueue.main.async {
                    viewModel.fetchRouteDetail(routeNo: routeNo)
                }
            }
            
        }
        if let selectedCustomer = viewModel.selectedCustomer,
           let customerLat = selectedCustomer.cust_Lat,
           let customerLong = selectedCustomer.cust_Log,
           let driverId = viewModel.routeDetails.first?.route.driverId {
            
            let customerLocation = CLLocationCoordinate2D(latitude: customerLat, longitude: customerLong)
            let mapViewModel = MapViewViewModel(driverLocationService: RouteService(), driverId: driverId, customerLocation: customerLocation)
            
            NavigationLink(
                destination: CustomerMapView(viewModel: viewModel),
                isActive: $viewModel.isShowingMapForCustomer
            ) {
                EmptyView()
            }.hidden()
        }
    }
    @ViewBuilder
    private var mapView: some View {
        if let driverId = viewModel.routeDetails.first?.route.driverId,
           let selectedCustomer = viewModel.selectedCustomer,
           let lat = selectedCustomer.cust_Lat,
           let long = selectedCustomer.cust_Log {
            MapView(viewModel: MapViewViewModel(
                driverLocationService: RouteService(),
                driverId: driverId,
                customerLocation: CLLocationCoordinate2D(latitude: lat, longitude: long)
            ))
        } else {
            // Handle the error scenario or provide a fallback view
            Text("Unable to fetch map details.")
        }
    }
    
    
    
    func routeInformationView(routeDetail: RouteDetailResponse) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Route Name: \(routeDetail.route.routeName ?? "")")
            Text("Route Number: \(routeDetail.route.routeNo ?? 1)")
            Text("Vehicle No: \(routeDetail.route.vehicleNo ?? "")")
            Text("No. of Customers: \(routeDetail.customer.count)")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red)
    }
    
    func customerListView(customers: [Customer]) -> some View {
        ForEach(customers, id: \.id) { customer in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(customer.customerName ?? "Unknown")
                        if customer.collectionStatus == "Collected" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    Text("\(customer.streetAddress ?? ""), \(customer.city ?? ""), \(customer.state ?? "")" )
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(customer.pickUpTime ?? "N/A")
                    Text("#\(customer.customerId ?? 0)")
                }
            }
            .padding(.vertical, 4)
            .onTapGesture {
                viewModel.selectedCustomer = customer
                viewModel.isShowingMapForCustomer = true  // This should trigger the NavigationLink
                
            }
        }
    }
    
}

#Preview {
    RoutesView(viewModel: RouteViewModel(), routeNo: 87)
}
