//
//  RouteService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

class RouteService {
    func getRouteDetails(routeNumber: Int, completion: @escaping (Result<[RouteDetailResponse], Error>) -> Void) {
        guard let url = URL(string: "\(Configuration.baseURL)\(Configuration.Endpoint.getRouteDetail)/?RouteNumber=\(routeNumber)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Int] = ["RouteNumber": routeNumber]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
                        
            do {
                let routeDetails = try JSONDecoder().decode([RouteDetailResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(routeDetails))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getDriverLocation(driverId: Int, completion: @escaping (Result<DriverLocation, Error>) -> Void) {
        let urlString = "\(Configuration.baseURL)\(Configuration.Endpoint.getDriverLocation)?DriverId=\(driverId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            do {
                let locations = try JSONDecoder().decode([DriverLocation].self, from: data)
                print("\(String(describing: locations))")
                if let location = locations.first {
                    DispatchQueue.main.async {
                        completion(.success(location))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(URLError(.cannotParseResponse)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func updateTransactionStatus(customerId: Int, numberOfSpecimens: Int, routeId: Int, status: Int, updateBy: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(Configuration.baseURL)\(Configuration.Endpoint.addUpdateTransactionStatus)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "CustomerId": customerId,
            "NumberOfSpecimens": numberOfSpecimens,
            "RouteId": routeId,
            "Status": status,
            "UpdateBy": updateBy
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            completion(.success(responseString ?? "Success"))
        }.resume()
    }
}
