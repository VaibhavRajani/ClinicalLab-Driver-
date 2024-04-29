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
                        print("Sign-up successful: \(response.result)")
                        self?.signUpFailed = false
                    case .failure(let error):
                        self?.signUpFailed = true
                        self?.handleError(error)
                    }
                }
            }
        }
        
        private func handleError(_ error: Error) {
            if let signUpError = error as? SignUpError {
                switch signUpError {
                case .accountExists:
                    failureMessage = "Driver account already exists."
                case .phoneNumberNotExists:
                    failureMessage = "Phone number not exists."
                case .failed:
                    failureMessage = "Sign up failed due to server error."
                case .unknown:
                    failureMessage = "An unknown error occurred."
                }
            } else {
                failureMessage = "An unexpected error occurred."
            }
        }
}
