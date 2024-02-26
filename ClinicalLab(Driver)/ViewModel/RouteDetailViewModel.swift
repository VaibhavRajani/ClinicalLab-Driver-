//
//  RouteDetailViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

class RouteViewModel: ObservableObject {
    @Published var routeDetails: RouteDetailResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let routeService: RouteService
    private let routeNumber: Int

    init(routeService: RouteService, routeNumber: Int) {
        self.routeService = routeService
        self.routeNumber = routeNumber
    }

    func loadRouteDetails() {
        isLoading = true
        routeService.getRouteDetails(routeNumber: routeNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let details):
                    self?.routeDetails = details
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
