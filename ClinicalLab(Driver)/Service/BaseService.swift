//
//  BaseService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 4/14/24.
//

import Foundation

class BaseService {
    func makeRequest<T: Decodable>(to endpoint: String, with body: Any, httpMethod: String = "POST", completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(Configuration.baseURL)\(endpoint)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body as? [String: Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        } else if let body = body as? Encodable {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
