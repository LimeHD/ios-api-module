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
    
    func test_timeInterval_createsCorrectValue() throws {
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3_600))
        XCTAssertEqual(timeZone.timeInterval, TimeInterval(timeZone.secondsFromGMT()))
    }
    
    func test_rfc3339DateStringInit_stringCountNotEqual25ReturnsNil() {
        let rfc3339Date = "TEST VALUE"
        let timeZone = TimeZone(rfc3339DateString: rfc3339Date)
        XCTAssertNil(timeZone)
    }
    
    func test_rfc3339DateStringInit_incorrectTimeZoneReturnsNil() {
        var rfc3339Date = "2020-06-02T15:00:00=TEST="
        var timeZone = TimeZone(rfc3339DateString: rfc3339Date)
        XCTAssertNil(timeZone)
        
        rfc3339Date = "2020-06-02T15:00:00+20:00"
        timeZone = TimeZone(rfc3339DateString: rfc3339Date)
        XCTAssertNil(timeZone)
    }
    
    func test_rfc3339DateStringInit_createsCorrectValue() throws {
        let rfc3339Date = "2020-06-02T15:00:00+03:00"
        let expectedTimeZone = TimeZone(secondsFromGMT: 3.hours)
        let actualTimeZone = try XCTUnwrap(TimeZone(rfc3339DateString: rfc3339Date))
        XCTAssertEqual(actualTimeZone, expectedTimeZone)
    }
}
