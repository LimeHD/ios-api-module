//
//  CharacterSet.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 18.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension CharacterSet {
    // https://stackoverflow.com/questions/1856785/characters-allowed-in-a-url
    // https://en.wikipedia.org/wiki/Percent-encoding#Types_of_URI_characters
    static var rfc3986Reserved: CharacterSet {
        return CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ")
    }
    static var rfc3986Allowed: CharacterSet {
        return CharacterSet.rfc3986Reserved.inverted
    }
}
