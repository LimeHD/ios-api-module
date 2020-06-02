//
//  URLTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class URLTests: XCTestCase {
    var sut: URL!

    override func setUp() {
        super.setUp()
        self.sut = URL(string: "https://limehd.tv/")!
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    func test_addQueryItemsWithEmptyParameters_urlIsNil() {
        let url = self.sut.addingQueryItems(parameters: [:], resolvingAgainstBaseURL: false)
        XCTAssertNil(url)
    }

}
