//
//  CharacterSet.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension CharacterSet {
    static var httpHostAllowed: CharacterSet {
        return CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
    }
}
