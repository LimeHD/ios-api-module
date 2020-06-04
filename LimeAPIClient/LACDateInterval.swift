//
//  LACDateInterval.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

/// Временной интервал между начальной и конечной датой с заданным часовым поясом
public struct LACDateInterval {
    var start: Date
    var end: Date
    var duration: TimeInterval = 0
    var timeZone = TimeZone.current
    
    /// Инициализирует интервал с  начальной и конечной датой равной текущей дате, временным интервалом равным 0 и часовым поясом используемым системой (TimeZone.current)
    public init() {
        let date = Date()
        self.start = date
        self.end = date
    }
    
    /// Инициализирует интервал с задаными начальной, конечной датой и часовым поясом
    /// - Parameters:
    ///   - start: начальная дата
    ///   - end: конечная дата
    ///   - timeZone: часовой пояс
    public init(start: Date, end: Date, timeZone: TimeZone) {
        self.start = start
        self.end = end
        self.duration = end.timeIntervalSince(self.start)
        self.timeZone = timeZone
    }
    
    /// Инициализирует интервал с задаными начальной датой, продолжительностью и часовым поясом
    /// - Parameters:
    ///   - start: начальная дата
    ///   - duration: продолжительность
    ///   - timeZone: часовой пояс
    public init(start: Date, duration: TimeInterval, timeZone: TimeZone) {
        self.start = start
        self.end = start.addingTimeInterval(duration)
        self.duration = duration
        self.timeZone = timeZone
    }
}
