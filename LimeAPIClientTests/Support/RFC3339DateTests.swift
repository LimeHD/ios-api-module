//
//  RFC3339DateTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 23.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class RFC3339DateTests: XCTestCase {
    var sut: RFC3339Date!

    func test_initTimeZoneDate_createsCorrectValues() throws {
        let date = Date()
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3_600))
        let expectedDate = date.adjustingByTimeZone(timeZone)
        let formatter = RFC3339DateFormatter(with: timeZone)
        
        self.sut = RFC3339Date(timeZoneDate: date, timeZone: timeZone)
        
        XCTAssertEqual(self.sut.timeZone, timeZone)
        XCTAssertEqual(self.sut.date, expectedDate)
        XCTAssertEqual(self.sut.unixTime, expectedDate.unixTime)
        XCTAssertEqual(self.sut.string, formatter.string(from: expectedDate))
    }

    func test_initDate_createsCorrectValues() throws {
        let date = Date()
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3_600))
        let formatter = RFC3339DateFormatter(with: timeZone)
        
        self.sut = RFC3339Date(date: date, timeZone: timeZone)
        
        XCTAssertEqual(self.sut.timeZone, timeZone)
        XCTAssertEqual(self.sut.date, date)
        XCTAssertEqual(self.sut.unixTime, date.unixTime)
        XCTAssertEqual(self.sut.string, formatter.string(from: date))
    }
    
    func test_initSting_invalidDateThrows() throws {
        let rfc3339Date = "INVALID VALUE"
        let expectedError = RFC3339DateError.invalidDateString(rfc3339Date)
        
        XCTAssertThrowsError(try RFC3339Date(string: rfc3339Date))
        
        do {
            _ = try RFC3339Date(string: rfc3339Date)
        } catch {
            let actualError = try XCTUnwrap(error as? RFC3339DateError)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(expectedError.localizedDescription)
        }
    }
    
    func test_initSting_invalidTimeZoneThrows() throws {
        let rfc3339Date = "2020-06-02T15:00:00+20:00"
        let expectedError = RFC3339DateError.invalidTimeZoneInString(rfc3339Date)
        
        XCTAssertThrowsError(try RFC3339Date(string: rfc3339Date))
        
        do {
            _ = try RFC3339Date(string: rfc3339Date)
        } catch {
            let actualError = try XCTUnwrap(error as? RFC3339DateError)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(expectedError.localizedDescription)
        }
    }
    
    func test_initSting_returnsCorrectDate() throws {
        let date = Date()
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 3_600))
        
        let expectedDate = RFC3339Date(date: date, timeZone: timeZone)
        
        XCTAssertNoThrow(try RFC3339Date(string: expectedDate.string))
        
        self.sut = try RFC3339Date(string: expectedDate.string)
        
        XCTAssertEqual(self.sut.timeZone, expectedDate.timeZone)
        XCTAssertEqual(self.sut.date.timeIntervalSinceReferenceDate, expectedDate.date.timeIntervalSinceReferenceDate, accuracy: 1.0)
        XCTAssertEqual(self.sut.unixTime, expectedDate.unixTime)
        XCTAssertEqual(self.sut.string, expectedDate.string)
    }
}
