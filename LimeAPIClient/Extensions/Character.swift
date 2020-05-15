//
//  Character.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension Character {
    var string: String { return String(self) }
    var isRussian: Bool {
        return self.string.isMatchedWith(regex: "[А-Яа-яЁё]")
    }
}
