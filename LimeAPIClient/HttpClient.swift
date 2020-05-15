//
//  HttpClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum HttpError: Error, LocalizedError, Equatable {
    case emptyData
    case unknownResponse
    case wrongStatusCode(_ statusCode: String)
    
    var errorDescription: String? {
        switch self {
        case .emptyData:
            let key = "В ответе сервера отсутствуют данные"
            return NSLocalizedString(key, comment: "Нет данных")
        case .unknownResponse:
            let key = "Ответ сервера не распознан"
            return NSLocalizedString(key, comment: "Ответ не распознан")
        case .wrongStatusCode(let statusCode):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode))"
            return NSLocalizedString(key, comment: statusCode)
        }
    }
}

class HttpClient {
    typealias httpResult = (Result<(data: Data, statusCode: String), Error>) -> Void
    
    let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }

    func getJSON(with request: URLRequest, completion: @escaping httpResult) {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = HttpError.emptyData
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = HttpError.unknownResponse
                completion(.failure(error))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let success = (data: data, statusCode: httpResponse.localizedStatusCode)
                completion(.success(success))
            } else {
                let error = HttpError.wrongStatusCode(httpResponse.localizedStatusCode)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
