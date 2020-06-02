//
//  URLRequestTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class URLRequestTests: XCTestCase {
    var sut: URLRequest!
    var url = URL(string: "https://limehd.tv/")!

    override func setUp() {
        super.setUp()
        self.sut = URLRequest(url: self.url)
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    func test_addURLQueryItemsWithEmptyParameters_queryIsEmpty() throws {
        self.sut.addURLQueryItems(parameters: [:], resolvingAgainstBaseURL: false)
        let url = try XCTUnwrap(self.sut.url)
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertNil(urlComponents?.query)
    }
    
    func test_addURLQueryItemsWithParameters_queryIsNotEmpty() throws {
        self.sut.addURLQueryItems(parameters: ["Test" : "test"], resolvingAgainstBaseURL: false)
        let url = try XCTUnwrap(self.sut.url)
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(urlComponents?.query)
    }
    
    func test_addBodyQueryItemsWithEmptyParameters_httpBodyIsEmpty() throws {
        self.sut.addBodyQueryItems(parameters: [:], dataEncoding: .utf8)
        XCTAssertNil(self.sut.httpBody)
    }
}
