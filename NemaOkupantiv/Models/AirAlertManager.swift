//
//  AirAlertManager.swift
//  NemaOkupantiv
//
//  Created by SHIN MIKHAIL on 25.01.2024.
//

import Foundation

func dniproAirAlertManager(completion: @escaping (Result<String, Error>) -> Void) {
    // URL для вашего запроса
    let urlString = "https://api.ukrainealarm.com/api/v3/alerts/9"

    // Создаем URL
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    // Создаем URLRequest
    var request = URLRequest(url: url)

    // Добавляем необходимые заголовки
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("d65d783b:718c3274fa6d11764408939ab0852dd5", forHTTPHeaderField: "Authorization")

    // Создаем URLSession
    let session = URLSession.shared

    // Выполняем запрос
    let task = session.dataTask(with: request) { (data, response, error) in
        // Проверяем наличие ошибок
        if let error = error {
            completion(.failure(error))
            return
        }

        // Проверяем наличие данных
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }

        // Преобразуем данные в строку (или JSON, если это JSON-ответ)
        if let responseString = String(data: data, encoding: .utf8) {
            completion(.success(responseString))
        } else {
            completion(.failure(NSError(domain: "Unable to parse response", code: 0, userInfo: nil)))
        }
    }

    // Запускаем задачу
    task.resume()
}

func performDniproAirAlertRequest() {
    dniproAirAlertManager { result in
        switch result {
        case .success(let responseString):
            // Выводим успешный результат
            print("Успешный результат: \(responseString)")
        case .failure(let error):
            // Выводим информацию об ошибке
            print("Ошибка: \(error.localizedDescription)")
        }
    }
}
