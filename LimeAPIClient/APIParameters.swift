//
//  APIParameters.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum APIParametersError: Error, LocalizedError, Equatable {
    case emptyUrl
    case invalidUrl(_ url: String)
    
    var errorDescription: String? {
        switch self {
        case .emptyUrl:
            let key = "Отсутствует url"
            return NSLocalizedString(key, comment: key)
        case .invalidUrl(let url):
            let key = "Не допустимое значение url: \(url)"
            return NSLocalizedString(key, comment: "Не допустимое url")
        }
    }
}

struct APIParameters {
    private let baseUrl: String
    private let endPoint: EndPoint
    let url: URL
    
    init(baseUrl: String, endPoint: EndPoint) throws {
        let baseUrl = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseUrl.isEmpty {
            throw APIParametersError.emptyUrl
        }
        
        guard let url = URL(string: baseUrl) else {
            throw APIParametersError.invalidUrl(baseUrl)
        }
        
        self.baseUrl = baseUrl
        self.endPoint = endPoint
        self.url = url.appendingPathComponent(endPoint.path)
    }
    
    var request: URLRequest {
        var request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod
        request.setHeaders(endPoint.headers)
        
        return request
    }
}
