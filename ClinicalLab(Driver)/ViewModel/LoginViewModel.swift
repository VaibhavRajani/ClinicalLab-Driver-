//
//  LoginViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var loginFailed: Bool = false
    var onLoginSuccess: ((Int) -> Void)?

    private var loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login() {
        loginService.login(phoneNumber: phoneNumber, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Update isAuthenticated when login is successful
                    self?.onLoginSuccess?(response.routeNo)
                    print(response.routeNo)
                case .failure(let error):
                    // Handle failure, show error message
                    self?.loginFailed = true
                    print(error.localizedDescription)
                }
            }
        }
    }
}


