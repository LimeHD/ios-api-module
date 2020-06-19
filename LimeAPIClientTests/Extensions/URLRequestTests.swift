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
    let baseUrl = "https://limehd.tv/"
    var url = URL(string: "https://limehd.tv/")!
    let endPoint = EndPoint.Factory.session()

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
    
    func test_handlerInit_notThrows() throws {
        XCTAssertNoThrow(try URLRequest(baseUrl: self.baseUrl, endPoint: self.endPoint))
    }
    
    func test_handlerInit_requestIsCorrect() throws {
        self.sut = try URLRequest(baseUrl: self.baseUrl, endPoint: self.endPoint)
        XCTAssertEqual(self.sut.timeoutInterval, 10)
        XCTAssertEqual(self.sut.cachePolicy, .useProtocolCachePolicy)
        XCTAssertEqual(self.sut.httpMethod, self.endPoint.httpMethod)
        XCTAssertEqual(self.sut.allHTTPHeaderFields?["Accept"], self.endPoint.acceptHeader)
    }
    
    func test_request_setsDefaultHeaders() throws {
        self.sut = try URLRequest(baseUrl: self.baseUrl, endPoint: self.endPoint)
        XCTAssertNotNil(self.sut.allHTTPHeaderFields)
        var isSetDefaulHeaders = true
        for (key, value) in HTTP.headers {
            if self.sut.allHTTPHeaderFields?[key] != value {
                isSetDefaulHeaders = false
                break
            }
        }
        XCTAssertTrue(isSetDefaulHeaders)
    }
}
