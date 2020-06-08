//
//  HTTPClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct HTTPStatusCodeError: Error, LocalizedError, Equatable {
    let data: Data
    let response: HTTPURLResponse
    
    public var errorDescription: String? {
        let statusCode = self.response.localizedStatusCode
        let key = "Неуспешный ответ состояния HTTP: \(statusCode)"
        return NSLocalizedString(key, comment: statusCode)
    }
}

public enum HTTPError: Error, LocalizedError, Equatable {
    case emptyData
    case unknownResponse
    case wrongStatusCode(_ statusCode: String, error: String)
    case jsonAPIError(_ statusCode: String, error: JSONAPIError)
    
    public var errorDescription: String? {
        switch self {
        case .emptyData:
            let key = "В ответе сервера отсутствуют данные"
            return NSLocalizedString(key, comment: "Нет данных")
        case .unknownResponse:
            let key = "Ответ сервера не распознан"
            return NSLocalizedString(key, comment: "Ответ не распознан")
        case .wrongStatusCode(let statusCode, let error):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode). Ошибка: \(error)"
            return NSLocalizedString(key, comment: statusCode)
        case .jsonAPIError(let statusCode, let error):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode). Ошибка: \(error)"
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
                self.decodeError(data, httpResponse, completion)
            }
        }
        
        task.resume()
    }
    
    private func decodeError(_ data: Data, _ httpResponse: HTTPURLResponse, _ completion: @escaping httpResult) {
        do {
            let jsonAPIError = try JSONAPIError(decoding: data)
            let error = HTTPError.jsonAPIError(httpResponse.localizedStatusCode, error: jsonAPIError)
            completion(.failure(error))
        } catch {
            let message = String(decoding: data, as: UTF8.self)
            let error = HTTPError.wrongStatusCode(httpResponse.localizedStatusCode, error: message)
            completion(.failure(error))
        }
    }
}
