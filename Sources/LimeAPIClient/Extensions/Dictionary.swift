//
//  Dictionary.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 25.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func dataEncodingQueryItems(using encoding: String.Encoding) -> Data? {
        guard !self.isEmpty else { return nil }
        var urlComponets = URLComponents()
        urlComponets.addQueryItems(parameters: self)
        return urlComponets.percentEncodedQuery?.data(using: .utf8)
    }
}
