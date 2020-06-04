//
//  DispatchQueueTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class DispatchQueueTests: XCTestCase {
    var sut: DispatchQueue!

    func test_async_callsAsynchronously() throws {
        self.sut = DispatchQueue.global()
        var workCompleted = false
        
        self.sut.async {
            workCompleted = true
        }
        
        XCTAssertFalse(workCompleted)
    }
    
    func test_async_callsCompletion() throws {
        self.sut = DispatchQueue.global()
        
        let expected = expectation(description: "callback happened")
        self.sut.async {
            expected.fulfill()
        }
        
        wait(for: [expected], timeout: 0.1)
    }
}
