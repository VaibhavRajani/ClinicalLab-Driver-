//
//  RoutesView.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation
import SwiftUI

struct RoutesView: View {
    @ObservedObject var viewModel: RouteViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let routeDetails = viewModel.routeDetails {
                List {
                    Section(header: Text("Route Information")) {
                        Text("Route Name: \(routeDetails.route.routeName ?? "")")
                        Text("Vehicle No: \(routeDetails.route.vehicleNo ?? "")")
                        Text("No. of Customers: \(routeDetails.customer.count)")
                    }
                    
                    Section(header: Text("Customers")) {
                        ForEach(routeDetails.customer, id: \.customerId) { customer in
                            VStack(alignment: .leading) {
                                Text(customer.customerName ?? "")
                                Text(customer.streetAddress ?? "")
                                Text("\(customer.city ?? ""), \(customer.state ?? "")")
                            }
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .onAppear {
            viewModel.loadRouteDetails()
        }
    }
}

// Replace with actual previews and dependencies
struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView(viewModel: RouteViewModel(routeService: RouteService(), routeNumber: 1))
    }
}
