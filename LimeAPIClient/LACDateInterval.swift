//
//  LACDateInterval.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

/// Временной интервал между начальной и конечной датой с заданным часовым поясом
///
/// Пример инициализации:
/// ```
/// // Начальная дата ранее текущей даты на 8 дней
/// let startDate = Date().addingTimeInterval(-8.days)
/// // Часовой пояс +3 часа
/// let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
/// // Временной интервал продолжительностью 15 дней
/// let dateInterval = LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
/// ```
public struct LACDateInterval {
    /// Начальная дата
    var start: Date
    /// Конечная дата
    var end: Date
    /// Продолжительность
    var duration: TimeInterval = 0
    /// Часовой пояс
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
    ///
    /// Пример инициализации:
    /// ```
    /// // Текущая дата
    /// let currentDate = Date()
    /// // Начальная дата ранее текущей даты на 8 дней
    /// let startDate = currentDate.addingTimeInterval(-8.days)
    /// // Конечная дата через 7 дней после текущей
    /// let endDate = currentDate.addingTimeInterval(7.days)
    /// // Временной интервал продолжительностью 15 дней
    /// /// // Часовой пояс +3 часа
    /// let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
    /// let dateInterval = LACDateInterval(start: startDate, end: endDate, timeZone: timeZone)
    /// ```
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
    ///
    /// Пример инициализации:
    /// ```
    /// // Начальная дата ранее текущей даты на 8 дней
    /// let startDate = Date().addingTimeInterval(-8.days)
    /// // Часовой пояс +3 часа
    /// let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
    /// // Временной интервал продолжительностью 15 дней
    /// let dateInterval = LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
    /// ```
    public init(start: Date, duration: TimeInterval, timeZone: TimeZone) {
        self.start = start
        self.end = start.addingTimeInterval(duration)
        self.duration = duration
        self.timeZone = timeZone
    }
}
