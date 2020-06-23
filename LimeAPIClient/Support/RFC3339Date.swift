//
//  RFC3339DateFormatter.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

class RFC3339DateFormatter: DateFormatter {
    override init() {
        super.init()
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        self.timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    convenience init(with timeZone: TimeZone) {
        self.init()
        self.timeZone = timeZone
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum RFC3339DateError: Error, LocalizedError, Equatable {
    case invalidDateString(_ inputString: String)
    case invalidTimeZoneInString(_ inputString: String)
    
    var errorDescription: String? {
        switch self {
        case let .invalidDateString(inputString):
            let key = "Не удалось распознать дату, возможно не соответсвует формату RFC3339: \(inputString). Используйте пример: 2020-06-18T19:17:28-01:00"
            return NSLocalizedString(key, comment: "Неверный формат данных")
        case let .invalidTimeZoneInString(inputString):
            let key = "Не удалось разспознать часовой пояс, возможно не соответсвует формату RFC3339: \(inputString). Используйте пример: 2020-06-18T19:17:28-01:00"
            return NSLocalizedString(key, comment: "Неверный формат данных")
        }
    }
}

struct RFC3339Date: Equatable {
    let date: Date
    let timeZone: TimeZone
    let string: String
    let unixTime: Int
    
    init(timeZoneDate: Date, timeZone: TimeZone) {
        self.timeZone = timeZone
        let date = timeZoneDate.adjustingByTimeZone(timeZone)
        self.date = date
        self.unixTime = date.unixTime
        let formatter = RFC3339DateFormatter(with: timeZone)
        self.string = formatter.string(from: date)
    }
    
    init(date: Date, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.date = date
        self.unixTime = date.unixTime
        let formatter = RFC3339DateFormatter(with: timeZone)
        self.string = formatter.string(from: date)
    }
    
    init(string: String) throws {
        self.string = string
        let formatter = RFC3339DateFormatter()
        
        guard let date = formatter.date(from: string) else {
            throw RFC3339DateError.invalidDateString(string)
        }
        self.date = date
        self.unixTime = date.unixTime
        
        guard let timeZone = TimeZone(rfc3339DateString: string) else {
            throw RFC3339DateError.invalidTimeZoneInString(string)
        }
        self.timeZone = timeZone
        formatter.timeZone = timeZone
    }
}
