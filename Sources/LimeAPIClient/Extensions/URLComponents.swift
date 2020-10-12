//
//  URLComponents.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 25.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension URLComponents {
    mutating func addQueryItems(parameters: [String: String]) {
        self.queryItems = parameters.map { key, value in
            URLQueryItem(
                name: key.encoding(with: .rfc3986Allowed),
                value: value.encoding(with: .rfc3986Allowed)
            )
        }
        self.percentEncodedQuery = self.percentEncodedQuery?.removingPercentEncoding
    }
}
