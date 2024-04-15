//
//  LoginService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

struct LoginResponse: Codable {
    let routeNo: Int
    
    enum CodingKeys: String, CodingKey {
        case routeNo = "RouteNo"
    }
}

enum LoginError: Error {
    case notExists
    case routeNotAssigned
    case passwordIncorrect
    case failed
    case unknown
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .notExists:
            return "Driver does not exist."
        case .routeNotAssigned:
            return "Route not assigned to driver."
        case .passwordIncorrect:
            return "Please check the password."
        case .failed:
            return "Login failed."
        case .unknown:
            return "An unknown error occurred."
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}

class LoginService: BaseService {
    func login(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let body = ["PhoneNumber": phoneNumber, "Password": password]
        let endpoint = Configuration.Endpoint.driverLogin
        makeRequest(to: endpoint, with: body, completion: completion)
    }
}

