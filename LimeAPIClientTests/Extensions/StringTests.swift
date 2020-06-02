//
//  StringTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 25.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class StringTests: XCTestCase {
    func test_filteringEmoji_emojiFilters() {
        let emoji = "😀"
        XCTAssertFalse(emoji.filteringEmoji.contains(emoji))
    }
    
    func test_filteringEmoji_lessOrEqual40Letters() {
        let emoji = String(repeating: "A", count: 60)
        XCTAssertEqual(emoji.filteringEmoji.count, 40)
    }
}
