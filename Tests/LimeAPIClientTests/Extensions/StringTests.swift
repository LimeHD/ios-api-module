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
    
    func test_int_correctValueReturnsInt() {
        let number = 123
        XCTAssertEqual("\(number)".int, number)
    }
    
    func test_int_invalidValueReturnsNil() {
        XCTAssertNil("TEST".int)
    }
    
    func test_subscript_returnsCorretValue() {
        XCTAssertEqual("TEST"[1], "E")
    }
    
    func test_timeIntervalInSeconds_wrongValueReturnsNil() {
        XCTAssertNil("TEST".timeIntervalInSeconds)
    }
    
    func test_timeIntervalInSeconds_returnsCorrectValue() {
        XCTAssertEqual("01:20".timeIntervalInSeconds, (60 + 20) * 60)
    }
}
