//
//  LACDateInterval.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct LACDateInterval {
    var start: Date
    var end: Date
    var duration: TimeInterval = 0
    var timeZone = TimeZone.current
    
    public init() {
        let date = Date()
        self.start = date
        self.end = date
    }
    
    public init(start: Date, end: Date, timeZone: TimeZone) {
        self.start = start
        self.end = end
        self.duration = end.timeIntervalSince(self.start)
        self.timeZone = timeZone
    }
    
    public init(start: Date, duration: TimeInterval, timeZone: TimeZone) {
        self.start = start
        self.end = start.addingTimeInterval(duration)
        self.duration = duration
        self.timeZone = timeZone
    }
}
