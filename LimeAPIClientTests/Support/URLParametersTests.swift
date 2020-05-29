//
//  URLParametersTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 25.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class URLParametersTests: XCTestCase {
    var sut: URLParameters!
    let baseUrl = "https://limehd.tv/"
    let endPoint = EndPoint.Factory.session()
    
    override func setUp() {
        super.setUp()
        self.sut = try? URLParameters(baseUrl: self.baseUrl, endPoint: self.endPoint)
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }

    func test_init_urCreates() throws {
        XCTAssertNotNil(self.sut.url)
    }
    
    func test_init_createsCorrectUrl() throws {
        let url = URL(string: self.baseUrl)?.appendingPathComponent(self.endPoint.path)
        XCTAssertEqual(self.sut.url, url)
    }
    
    func test_requestIsCorrect() {
        XCTAssertEqual(self.sut.request.httpMethod, self.endPoint.httpMethod)
        XCTAssertEqual(self.sut.request.allHTTPHeaderFields?["Accept"], self.endPoint.acceptHeader)
    }
    
    func test_request_setsDefaultHeaders() {
        XCTAssertNotNil(self.sut.request.allHTTPHeaderFields)
        var isSetDefaulHeaders = true
        for (key, value) in HTTP.headers {
            if self.sut.request.allHTTPHeaderFields?[key] != value {
                isSetDefaulHeaders = false
                break
            }
        }
        XCTAssertTrue(isSetDefaulHeaders)
    }
}