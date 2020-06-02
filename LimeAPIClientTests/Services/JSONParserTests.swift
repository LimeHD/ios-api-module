//
//  JSONParserTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 19.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class JSONParserTests: XCTestCase {
    var sut: JSONParser!
    var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.sut = JSONParser(self.decoder)
    }
    
    override func tearDown() {
        self.decoder = nil
        self.sut = nil
        super.tearDown()
    }
    
    func test_init_sets_decoder() {
        XCTAssertTrue(self.sut.decoder === self.decoder)
    }
    
    func test_decode_givenInvalidJSON_returnsFailure() throws {
        var expectedData: JSONAPIError? = nil
        var expectedError: Error? = nil
        let data = try XCTUnwrap(JSONAPIErrorExample.incorrectData.data(using: .utf8))
        let result = self.sut.decode(JSONAPIError.self, data)
        
        
        switch result {
        case .success(let data):
            expectedData = data
        case .failure(let error):
            expectedError = error
        }
        
        XCTAssertNil(expectedData)
        XCTAssertNotNil(expectedError)
    }
    
    func test_decode_givenCorrectJSON_returnsSuccess() throws {
        var expectedData: JSONAPIError? = nil
        var expectedError: Error? = nil
    
        let data = try XCTUnwrap(JSONAPIErrorExample.standart.data(using: .utf8))
        let result = self.sut.decode(JSONAPIError.self, data)
        
        switch result {
        case .success(let data):
            expectedData = data
        case .failure(let error):
            expectedError = error
        }
        
        XCTAssertNotNil(expectedData)
        XCTAssertNil(expectedError)
    }
}
