//
//  TimeIntervalTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class TimeIntervalTests: XCTestCase {
    var sut: TimeInterval!
    
    func test_minutes_createsCorrectTimeInterval() {
        let number = 5.0
        self.sut = number.minutes
        XCTAssertEqual(self.sut, number * 60)
    }
    
    func test_hours_createsCorrectTimeInterval() {
        let number = 5.0
        self.sut = number.hours
        XCTAssertEqual(self.sut, number * 3_600)
    }
}
