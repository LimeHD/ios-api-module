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
        if let url = self.url?.addQueryItems(parameters: parameters, resolvingAgainstBaseURL: resolve) {
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
