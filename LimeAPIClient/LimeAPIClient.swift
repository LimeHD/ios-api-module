//
//  LimeAPIClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

let module = NSStringFromClass(LimeAPIClient.self).components(separatedBy:".")[0]

enum ApiError: Error, LocalizedError, Equatable {
    case emptyUrl
    case invalidUrl(_ url: String)
    
    var errorDescription: String? {
        switch self {
        case .emptyUrl:
            let key = "Отсутствует url"
            return NSLocalizedString(key, comment: key)
        case .invalidUrl(let url):
            let url = url.isEmpty ? "(отсутствует)" : url
            let key = "Не допустимое значение url: \(url)"
            return NSLocalizedString(key, comment: "Не допустимое url")
        }
    }
}

public typealias ApiResult<T: Decodable> = (Result<T, Error>) -> Void

public final class LimeAPIClient {
    static public func request<T: Decodable>(_ type: T.Type, url: String, endPoint: EndPoint, completion: @escaping ApiResult<T>) {
        let url = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if url.isEmpty {
            let error = ApiError.emptyUrl
            LimeAPIClient.log(url, message: error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        guard let requestUrl = URL(string: url) else {
            let error = ApiError.invalidUrl(url)
            LimeAPIClient.log(url, message: error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        let request = URLRequest(url: requestUrl, endPoint: endPoint)
        HttpClient(URLSession.shared).getJSON(with: request) { (result) in
            switch result {
            case .success(let result):
                LimeAPIClient.log(url, message: result.statusCode)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let parser = JSONParser(decoder)
                
                let result = parser.decode(JSONAPIObject<T>.self, result.data)
                switch result {
                case .success(let data):
                    completion(.success(data.data))
                case .failure(let error):
                    LimeAPIClient.log(url, message: error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                LimeAPIClient.log(url, message: error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    private static func log(_ url: String, message: String) {
        let url = url.isEmpty ? "(пустое значение ulr)" : url
        print("\(module)\n\(url)\n\(message)")
    }
}
