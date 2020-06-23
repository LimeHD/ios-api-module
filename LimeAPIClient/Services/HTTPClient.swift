//
//  HTTPClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

class HTTPClient {
    typealias ClientCompletion = (Result<HTTP.Result, Swift.Error>) -> Void
    
    public enum Error: Swift.Error, Equatable {
        case emptyData
        case unknownResponse
        case wrongStatusCode(_ data: Data, _ response: HTTPURLResponse)
    }
    
    let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    func dataTask(with request: URLRequest, completion: @escaping ClientCompletion) {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = HTTPClient.Error.emptyData
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = HTTPClient.Error.unknownResponse
                completion(.failure(error))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let httpResult = HTTP.Result(data: data, response: httpResponse)
                completion(.success(httpResult))
            } else {
                let error = HTTPClient.Error.wrongStatusCode(data, httpResponse)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

extension HTTPClient.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyData:
            let key = "В ответе сервера отсутствуют данные"
            return NSLocalizedString(key, comment: "Нет данных")
        case .unknownResponse:
            let key = "Ответ сервера не распознан"
            return NSLocalizedString(key, comment: "Ответ не распознан")
        case let .wrongStatusCode(_, response):
            let statusCode = response.localizedStatusCode
            let key = "Неуспешный ответ состояния HTTP: \(statusCode)"
            return NSLocalizedString(key, comment: statusCode)
        }
    }
}
