//
//  BroadcastTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 23.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class BroadcastTests: XCTestCase {
    var sut: Broadcast!

    func test_startAtUnix_wrongStartAtReturnsNil() {
        let attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: "", finishAt: "")
        self.sut = Broadcast(id: "", type: "", attributes: attributes)
        
        XCTAssertNil(self.sut.startAtUnix)
    }
    
    func test_startAtUnix_startAtReturnsCorrectValue() throws {
        let rfc3339Date = "2020-06-02T15:00:00+03:00"
        let expectedStartAt = try XCTUnwrap(try RFC3339Date(string: rfc3339Date))
        
        let attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: rfc3339Date, finishAt: "")
        self.sut = Broadcast(id: "", type: "", attributes: attributes)
        
        XCTAssertEqual(self.sut.startAtUnix, expectedStartAt.unixTime)
    }

    func test_duration_wrongValuesReturnsNil() {
        let rfc3339Date = "2020-06-02T15:00:00+03:00"
        var attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: "", finishAt: "")
        self.sut = Broadcast(id: "", type: "", attributes: attributes)
        
        XCTAssertNil(self.sut.duration)
        
        attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: rfc3339Date, finishAt: "")
        self.sut = Broadcast(id: "", type: "", attributes: attributes)
        
        XCTAssertNil(self.sut.duration)
        
        attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: "", finishAt: rfc3339Date)
        self.sut = Broadcast(id: "", type: "", attributes: attributes)
        
        XCTAssertNil(self.sut.duration)
    }
    
    func test_startAtUnix_durationReturnsCorrectValue() throws {
        let startAt = "2020-06-02T00:00:00+03:00"
        let finishAt = "2020-06-02T15:00:00+03:00"
        let expectedStartAt = try XCTUnwrap(try RFC3339Date(string: startAt))
        let expectedFinishAt = try XCTUnwrap(try RFC3339Date(string: finishAt))
        let expectedDuration = expectedFinishAt.unixTime - expectedStartAt.unixTime

        let attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: startAt, finishAt: finishAt)
        self.sut = Broadcast(id: "", type: "", attributes: attributes)

        XCTAssertEqual(self.sut.duration, expectedDuration)
    }
}
