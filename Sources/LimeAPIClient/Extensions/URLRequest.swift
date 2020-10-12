//
//  URLRequest.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func setHeaders(parameters: [String: String]) {
        for (key, value) in parameters {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    mutating func addURLQueryItems(parameters: [String : String], resolvingAgainstBaseURL resolve: Bool) {
        guard !parameters.isEmpty else { return }
        if let url = self.url?.addingQueryItems(parameters: parameters, resolvingAgainstBaseURL: resolve) {
            self.url = url
        }
    }
    
    mutating func addBodyQueryItems(parameters: [String : String], dataEncoding: String.Encoding) {
        guard !parameters.isEmpty else { return }
        if let httpBody = parameters.dataEncodingQueryItems(using: dataEncoding) {
            self.httpBody = httpBody
        }
    }
}

//MARK: LimeAPIClientHandlers

public enum URLRequestError: Error, LocalizedError, Equatable {
    case emptyUrl
    case invalidUrl(_ url: String)
    
    public var errorDescription: String? {
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

extension URLRequest {
    init(baseUrl: String, endPoint: EndPoint) throws {
        let baseUrl = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseUrl.isEmpty {
            throw URLRequestError.emptyUrl
        }
        guard var url = URL(string: baseUrl) else {
            throw URLRequestError.invalidUrl(baseUrl)
        }
        
        if !endPoint.path.isEmpty {
            url = url.appendingPathComponent(endPoint.path)
        }
        let path = url.absoluteString
        self = try URLRequest(path: path, endPoint: endPoint)
    }
    
    init(path: String, endPoint: EndPoint = EndPoint()) throws {
        guard let url = URL(string: path) else {
            throw URLRequestError.invalidUrl(path)
        }
        
        var request = URLRequest(url: url, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod
        request.setHeaders(parameters: HTTP.headers)
        
        if !endPoint.acceptHeader.isEmpty {
            request.setValue(endPoint.acceptHeader, forHTTPHeaderField: "Accept")
        }
        
        request.addURLQueryItems(parameters: endPoint.parameters.url, resolvingAgainstBaseURL: false)
        request.addBodyQueryItems(parameters: endPoint.parameters.body, dataEncoding: .utf8)
        if request.httpBody != nil {
            request.setValue(HTTP.Header.ContentType.urlEncodedForm, forHTTPHeaderField: "Content-Type")
        }
        
        self = request
    }
}
