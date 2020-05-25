//
//  URLParameters.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum URLParametersError: Error, LocalizedError, Equatable {
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

struct URLParameters {
    private let baseUrl: String
    private let endPoint: EndPoint
    let url: URL
    
    init(baseUrl: String, endPoint: EndPoint) throws {
        let baseUrl = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseUrl.isEmpty {
            throw URLParametersError.emptyUrl
        }
        
        guard let url = URL(string: baseUrl) else {
            throw URLParametersError.invalidUrl(baseUrl)
        }
        
        self.baseUrl = baseUrl
        self.endPoint = endPoint
        self.url = url.appendingPathComponent(endPoint.path)
    }
    
    var request: URLRequest {
        var request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = self.endPoint.httpMethod
        request.setValue(self.endPoint.acceptHeader, forHTTPHeaderField: "Accept")
        request.setHeaders(parameters: HTTP.headers)
        
        let urlParameters = self.endPoint.parameters.url
        if !urlParameters.isEmpty {
            if let url = self.url.addQueryItems(parameters: urlParameters, resolvingAgainstBaseURL: false) {
                request.url = url
            }
        }
        
        if let data = self.addBodyParameters() {
            request.httpBody = data
            request.setValue(HTTP.Header.ContentType.urlEncodedForm, forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func addBodyParameters() -> Data? {
        guard !self.endPoint.parameters.body.isEmpty else { return nil }
        
        return self.endPoint.parameters.body
            .map { key, value in
            let escapedKey = key.encoding(with: .rfc3986Allowed)
            let escapedValue = value.encoding(with: .rfc3986Allowed)
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
