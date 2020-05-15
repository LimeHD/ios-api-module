//
//  String.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension String {
    func isMatchedWith(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
    
    var filteringEmoji: String {
        let maxLength = 40
        var result = ""
        self.forEach {
            if $0.isRussian || $0.isASCII {
                result += $0.string
            } else {
                $0.unicodeScalars.forEach {
                    result += "[\($0.value)]"
                }
            }
        }
        result = result.replacingOccurrences(of: "][", with: ", ")
        result = result.count <= maxLength ? result : result.prefix(maxLength - 3) + "..."
        return result
    }
}
