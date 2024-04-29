//
//  SignUpService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

struct SignUpResponse: Codable {
    let result: String
}

enum SignUpError: Error {
    case accountExists, phoneNumberNotExists, failed, unknown
}

class SignUpService: BaseService {
    func signUp(phoneNumber: String, password: String, confirmPassword: String, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        let endpoint = Configuration.Endpoint.driverSignUp
        let signUpRequest = SignUpRequest(phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword)
        makeRequest(to: endpoint, with: signUpRequest, completion: completion)
    }
}

