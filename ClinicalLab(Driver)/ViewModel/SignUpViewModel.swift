//
//  SignUpViewModel.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var signUpFailed: Bool = false
    @Published var failureMessage: String = ""
    
    private var signUpService: SignUpService
    
    init(signUpService: SignUpService) {
        self.signUpService = signUpService
    }
    
    func signUp() {
        signUpService.signUp(phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Handle success, navigate to next screen or store the user session
                    print(response.result)
                case .failure(let error):
                    self?.signUpFailed = true
                    switch error {
                    case .accountExists:
                        self?.failureMessage = "Driver account already exists."
                    case .phoneNumberNotExists:
                        self?.failureMessage = "Phone number not exists."
                    default:
                        self?.failureMessage = "An unknown error occurred."
                    }
                }
            }
        }
    }
}
