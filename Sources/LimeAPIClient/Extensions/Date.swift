//
//  Date.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension Date {
    func adjustingByTimeZone(_ timeZone: TimeZone) -> Date {
        self.addingTimeInterval(-timeZone.timeInterval)
    }
    
    var unixTime: Int { self.timeIntervalSince1970.int }
}
