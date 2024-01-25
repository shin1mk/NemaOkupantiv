//
//  WarfareManager.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

import Foundation

class WarshipAPIManager {
    static let shared = WarshipAPIManager()
    
    private init() { }
    
    func fetchWarfareData(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://russianwarship.rip/api/v1/statistics/latest"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                print("No data received")
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
