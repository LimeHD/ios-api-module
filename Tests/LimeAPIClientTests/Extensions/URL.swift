//
//  URL.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 23.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil }

        var dictionary = [String: String]()
        query.components(separatedBy: "&").forEach { (pair) in
            let queryItem = pair.components(separatedBy: "=")
            let key = queryItem[0]
            let value = queryItem[1]

            dictionary[key] = value
        }
        
        return dictionary
    }
}
