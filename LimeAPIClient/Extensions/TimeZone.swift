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
