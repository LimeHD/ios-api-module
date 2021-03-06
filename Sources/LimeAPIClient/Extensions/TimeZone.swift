//
//  TimeZone.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension TimeZone {
    var utcString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "'UTC'xxx"
        formatter.timeZone = self
        return formatter.string(from: Date())
    }
}

//MARK: - Support Methods for RFC3339Date

public extension TimeZone {
    var timeInterval: TimeInterval {
        TimeInterval(self.secondsFromGMT())
    }
    
    init?(rfc3339DateString string: String) {
        if string.count != 25 { return nil }
        self.init(utcString: string)
    }
    
    init?(utcString string: String) {
        if string.count < 6 { return nil }
        let timeZoneWithSign = String(string.suffix(6))
        let stringTimeZone = String(timeZoneWithSign.suffix(5))
        let sign: Int
        switch timeZoneWithSign[0] {
        case "+": sign = 1
        case "-": sign = 1
        default: return nil
        }
        guard let timeInterval = stringTimeZone.timeIntervalInSeconds else { return nil }
        let seconds = sign * timeInterval
        guard let timeZone = TimeZone(secondsFromGMT: seconds) else { return nil }
        self = timeZone
    }
}
