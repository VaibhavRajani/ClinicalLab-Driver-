//
//  LoginService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

struct LoginResponse: Codable {
    let routeNo: Int
    
    // Coding keys to match the JSON keys exactly if they're case sensitive.
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
    case decodingError(String) // To handle decoding errors with a message
    
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

class LoginService {
    func login(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponse, LoginError>) -> Void) {
        guard let url = URL(string: "https://pclwebapi.azurewebsites.net/api/Driver/DriverLogin") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["PhoneNumber": phoneNumber, "Password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Networking error: \(error.localizedDescription)")
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(loginResponse))
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                completion(.failure(.decodingError(decodingError.localizedDescription)))
            }
        }
        
        task.resume()
    }
}



