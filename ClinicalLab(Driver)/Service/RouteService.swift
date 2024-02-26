//
//  RouteService.swift
//  ClinicalLab(Driver)
//
//  Created by Vaibhav Rajani on 2/25/24.
//

import Foundation

class RouteService {
    func getRouteDetails(routeNumber: Int, completion: @escaping (Result<RouteDetailResponse, Error>) -> Void) {
        guard let url = URL(string: "https://pclwebapi.azurewebsites.net/api/Route/GetRouteDetail/?RouteNumber=\(routeNumber)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Include any additional headers or body as required by your API.
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let routeDetails = try JSONDecoder().decode(RouteDetailResponse.self, from: data)
                completion(.success(routeDetails))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
