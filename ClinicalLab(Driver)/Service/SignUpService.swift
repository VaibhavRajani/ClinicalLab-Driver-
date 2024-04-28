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

class SignUpService {
    func signUp(phoneNumber: String, password: String, confirmPassword: String, completion: @escaping (Result<SignUpResponse, SignUpError>) -> Void) {
        guard let url = URL(string: "\(Configuration.baseURL)\(Configuration.Endpoint.driverSignUp)") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let signUpRequest = SignUpRequest(phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword)
        request.httpBody = try? JSONEncoder().encode(signUpRequest)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Networking error: \(error.localizedDescription)")
                completion(.failure(.unknown))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(.failure(.failed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                _ = try JSONDecoder().decode(LoginResponse.self, from: data)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(.unknown))
            }
        }

        
        task.resume()
    }
}

