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

extension String {
    func encoding(with allowedCharacters: CharacterSet) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}

public extension String {
    var int: Int? { Int(self) }
}

//MARK: - Support Methods for RFC3339Date

extension String {
    subscript(i: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index].string
    }
    
    var timeIntervalInSeconds: Int? {
        let stringComponents = self.components(separatedBy: ":")
        var timeComponents = [Int]()
        for value in stringComponents {
            if let value = Int(value) {
                timeComponents.append(value)
            } else {
                return nil
            }
        }
        let timeInterval = timeComponents[0].hours + timeComponents[1].minutes
        return timeInterval
    }
}
