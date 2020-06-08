//
//  HTTPClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public enum HTTPError: Error, LocalizedError, Equatable {
    case emptyData
    case unknownResponse
    case wrongStatusCode(_ data: Data, _ response: HTTPURLResponse)
    
    public var errorDescription: String? {
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

class HTTPClient {
    typealias httpResult = (Result<HTTP.Result, Error>) -> Void
    
    let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    func dataTask(with request: URLRequest, completion: @escaping httpResult) {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = HTTPError.emptyData
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = HTTPError.unknownResponse
                completion(.failure(error))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let httpResult = HTTP.Result(data: data, response: httpResponse)
                completion(.success(httpResult))
            } else {
                let error = HTTPError.wrongStatusCode(data, httpResponse)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
