//
//  TimeInterval.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public extension TimeInterval {
    var minutes: TimeInterval { self * 60 }
    var hours: TimeInterval { self * 3_600 }
    var days: TimeInterval { self * 86_400 }
}
