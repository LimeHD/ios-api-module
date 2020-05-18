//
//  Date.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension Date {
    func rfc3339String(for timeZone: TimeZone) -> String {
        let formatter = RFC3339DateFormatter()
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
