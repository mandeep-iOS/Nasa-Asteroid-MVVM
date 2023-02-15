//
//  APIService.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    func fetchData(startDate: String, endDate: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=GUr89ayX3diirvcCn7mSZB6kE9PZfaDCKZfyeXAv")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

enum APIServiceError: Error {
  case noData
}
//https://api.nasa.gov/neo/rest/v1/feed?start_date=2023-02-01&end_date=2023-02-12&api_key=GUr89ayX3diirvcCn7mSZB6kE9PZfaDCKZfyeXAv
