//
//  LACParameters.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum LACParametersError: Error, LocalizedError, Equatable {
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

struct LACParameters {
    private let baseUrl: String
    private let appId: String
    private let endPoint: EndPoint
    let url: URL
    
    init(baseUrl: String, appId: String, endPoint: EndPoint) throws {
        let baseUrl = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseUrl.isEmpty {
            throw LACParametersError.emptyUrl
        }
        
        guard let url = URL(string: baseUrl) else {
            throw LACParametersError.invalidUrl(baseUrl)
        }
        
        self.baseUrl = baseUrl
        self.appId = appId
        self.endPoint = endPoint
        self.url = url.appendingPathComponent(endPoint.path)
    }
    
    var request: URLRequest {
        var request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = self.endPoint.httpMethod
        request.setHeaders(self.endPoint.headers(with: self.appId))
        
        if let url = self.addUrlParameters() {
            request.url = url
        }
        
        return request
    }
    
    private func addUrlParameters() -> URL? {
        guard !self.endPoint.urlParameters.isEmpty else { return nil }
        if var urlComponents = URLComponents(url: self.url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in self.endPoint.urlParameters {
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents.queryItems?.append(queryItem)
            }
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.removingPercentEncoding
            return urlComponents.url
        }
        return nil
    }
}
