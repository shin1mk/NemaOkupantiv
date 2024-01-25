//
//  FetchData.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 06.01.2024.
//

import Foundation

class DateDayManager {
    static let shared = DateDayManager()
    
    private init() {}
    // получаем дату
    func fetchCurrentDate() -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "dd.MM.yyyy"
        return dateFormatterDate.string(from: Date())
    }
    // получаем количество дней
    func fetchDaysData(completion: @escaping (Int?) -> Void) {
        let urlString = "https://russianwarship.rip/api/v1/statistics/latest"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let dataDict = json["data"] as? [String: Any],
                               let day = dataDict["day"] as? Int {
                                print("Response JSON: \(json)")
                                completion(day)
                            } else {
                                print("Invalid JSON format")
                                completion(nil)
                            }
                        } else {
                            print("Failed to parse JSON")
                            completion(nil)
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        completion(nil)
                    }
                    
                }
            } else {
                print("Invalid response")
                completion(nil)
            }
        }
        task.resume()
    }
}
