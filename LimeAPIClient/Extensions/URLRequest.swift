//
//  URLRequest.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension URLRequest {
    init(url: URL, endPoint: EndPoint) {
        self = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        self.httpMethod = endPoint.httpMethod
        self.setHeaders(endPoint.headers)
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}
