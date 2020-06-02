//
//  TimeZoneTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class TimeZoneTests: XCTestCase {
    var sut: TimeZone!

    func test_utcString_createsCorrectString() {
        self.sut = TimeZone(secondsFromGMT: 3.hours)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "'UTC'xxx"
        formatter.timeZone = self.sut
        let expectedString = formatter.string(from: Date())
        
        XCTAssertEqual(self.sut.utcString, expectedString)
    }
}
