//
//  Int.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public extension Int {
    var minutes: Int { self * 60 }
    var hours: Int { self * 3_600 }
    var string: String { "\(self)" }
}
