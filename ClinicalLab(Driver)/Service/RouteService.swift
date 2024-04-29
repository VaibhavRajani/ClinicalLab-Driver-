//  RouteService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

class RouteService: BaseService {
    func getRouteDetails(routeNumber: Int, completion: @escaping (Result<[RouteDetailResponse], Error>) -> Void) {
        let endpoint = "\(Configuration.Endpoint.getRouteDetail)/?RouteNumber=\(routeNumber)"
        let body: [String: Int] = ["RouteNumber": routeNumber]
        makeRequest(to: endpoint, with: body, httpMethod: "POST", completion: completion)
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
        let endpoint = Configuration.Endpoint.addUpdateTransactionStatus
        let body: [String: Any] = [
            "CustomerId": customerId,
            "NumberOfSpecimens": numberOfSpecimens,
            "RouteId": routeId,
            "Status": status,
            "UpdateBy": updateBy
        ]
        makeRequest(to: endpoint, with: body, httpMethod: "POST", completion: completion)
    }
}
