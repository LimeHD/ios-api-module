//
//  LACDateIntervalTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class LACDateIntervalTests: XCTestCase {
    var sut: LACDateInterval!
    
    func test_init_setsCorrectValues() {
        self.sut = LACDateInterval()
        
        XCTAssertEqual(self.sut.start, self.sut.end)
        XCTAssertEqual(self.sut.duration, 0)
        XCTAssertEqual(self.sut.timeZone, TimeZone.current)
    }
    
    func test_initWithStartEndTimeZone_setsCorrectValues() throws {
        let start = Date().addingTimeInterval(-1.days)
        let end = Date()
        let duration = end.timeIntervalSince(start)
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3.hours))
        self.sut = LACDateInterval(start: start, end: end, timeZone: timeZone)
        
        XCTAssertEqual(self.sut.start, start)
        XCTAssertEqual(self.sut.end, end)
        XCTAssertEqual(self.sut.duration, duration)
        XCTAssertEqual(self.sut.timeZone, timeZone)
    }
    
    func test_initWithStartDurationTimeZone_setsCorrectValues() throws {
        let start = Date().addingTimeInterval(-1.days)
        let duration: TimeInterval = 2.days
        let end = start.addingTimeInterval(duration)
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3.hours))
        self.sut = LACDateInterval(start: start, duration: duration, timeZone: timeZone)
        
        XCTAssertEqual(self.sut.start, start)
        XCTAssertEqual(self.sut.end, end)
        XCTAssertEqual(self.sut.duration, duration)
        XCTAssertEqual(self.sut.timeZone, timeZone)
    }
}
