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
    @State private var showingSettings = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showingLogin = false
    @State private var showingMap = false

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.routeDetails.isEmpty {
                    Text("Fetching route details...")
                } else {
                    ForEach(viewModel.routeDetails, id: \.route.routeNo) { routeDetail in
                        viewModel.routeInformationView(routeDetail: routeDetail)
                        viewModel.customerListView(customers: routeDetail.customer)
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .navigationBarItems(
                trailing: HStack{
//                    NavigationLink(
//                        destination: LoginView(viewModel: LoginViewModel(loginService: LoginService())),
//                        isActive: $showingLogin
//                    ) {
//                        EmptyView()
//                    }
                  
                    Button("Sign Out") {
                        showingLogin = true
                    }
                    .foregroundColor(.red)
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }}
            )
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $showingLogin) {
                            LoginView(viewModel: LoginViewModel(loginService: LoginService()))
                        }
            .navigationDestination(isPresented: $showingMap) {
                if let selectedCustomer = viewModel.selectedCustomer,
                   let lat = selectedCustomer.cust_Lat,
                   let long = selectedCustomer.cust_Log {
                    CustomerMapView(viewModel: viewModel)
                } else {
                    Text("Unable to fetch map details.")
                }
            }
            .fullScreenCover(isPresented: $showingLogin) {
                LoginView(viewModel: LoginViewModel(loginService: LoginService()))
            }
            .onAppear {
                DispatchQueue.main.async {
                    viewModel.fetchRouteDetail(routeNo: routeNo)
                }
            }
            
        }
        .toolbarBackground(
            Color.customPink,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.selectedCustomer) {
            showingMap = viewModel.isShowingMapForCustomer && viewModel.selectedCustomer != nil
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
            Text("Unable to fetch map details.")
        }
    }
    
}

#Preview {
    RoutesView(viewModel: RouteViewModel(), routeNo: 87)
}
