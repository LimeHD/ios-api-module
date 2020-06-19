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
    let request: URLRequest
    
    init(baseUrl: String, endPoint: EndPoint = EndPoint()) throws {
        let baseUrl = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if baseUrl.isEmpty {
            throw URLParametersError.emptyUrl
        }
        guard var url = URL(string: baseUrl) else {
            throw URLParametersError.invalidUrl(baseUrl)
        }
        
        if !endPoint.path.isEmpty {
            url = url.appendingPathComponent(endPoint.path)
        }
        self.request = URLParameters.createRequest(url: url, endPoint: endPoint)
    }
    
    static private func createRequest(url: URL, endPoint: EndPoint) -> URLRequest {
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
        
        return request
    }

}
