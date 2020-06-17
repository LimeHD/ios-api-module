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
    private let endPoint: EndPoint?
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
    
    init(path: String) throws {
        let path = path.trimmingCharacters(in: .whitespacesAndNewlines)
        if path.isEmpty {
            throw URLParametersError.emptyUrl
        }
        
        guard let url = URL(string: path) else {
            throw URLParametersError.invalidUrl(path)
        }
        
        self.baseUrl = ""
        self.endPoint = nil
        self.url = url
    }
    
    var request: URLRequest {
        var request = URLRequest(url: self.url, timeoutInterval: 10.0)
        request.httpMethod = self.endPoint?.httpMethod ?? HTTP.Method.get
        request.setHeaders(parameters: HTTP.headers)
        
        guard let endPoint = self.endPoint else { return request }
        
        request.setValue(endPoint.acceptHeader, forHTTPHeaderField: "Accept")
        
        request.addURLQueryItems(parameters: endPoint.parameters.url, resolvingAgainstBaseURL: false)
        request.addBodyQueryItems(parameters: endPoint.parameters.body, dataEncoding: .utf8)
        if request.httpBody != nil {
            request.setValue(HTTP.Header.ContentType.urlEncodedForm, forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }

}
