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

extension TimeZone {
    var timeInterval: TimeInterval {
        TimeInterval(self.secondsFromGMT())
    }
    
    init?(rfc3339DateString string: String) {
        let stringTimeZone = String(string.suffix(5))
        let sign = string[19] == "+" ? 1 : -1
        guard let timeInterval = stringTimeZone.timeIntervalInSeconds else { return nil }
        let seconds = sign * timeInterval
        guard let timeZone = TimeZone(secondsFromGMT: seconds) else { return nil }
        self = timeZone
    }
}
