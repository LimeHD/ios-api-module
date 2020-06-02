//
//  RFC3339DateFormatterTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class RFC3339DateFormatterTests: XCTestCase {
    var sut: RFC3339DateFormatter!

    func test_init_createsCorrectDateFormat() {
        self.sut = RFC3339DateFormatter()
        
        XCTAssertEqual(self.sut.dateFormat, "yyyy-MM-dd'T'HH:mm:ssxxx")
    }
}
