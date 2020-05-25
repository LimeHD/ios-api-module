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
}
