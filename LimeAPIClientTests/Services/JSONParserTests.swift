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
        let result = try self.parseJSON(JSONAPIErrorExample.incorrectData)
        
        XCTAssertNil(result.json)
        XCTAssertNotNil(result.error)
    }
    
    typealias JSONResult = (json: JSONAPIError?, error: Error?)
    
    func parseJSON(_ jsonString: String) throws -> JSONResult {
        var expectedData: JSONAPIError? = nil
        var expectedError: Error? = nil
        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let result = self.sut.decode(JSONAPIError.self, data)
        
        switch result {
        case .success(let data):
            expectedData = data
        case .failure(let error):
            expectedError = error
        }
        
        return (expectedData, expectedError)
    }
    
    func test_decode_givenCorrectJSON_returnsSuccess() throws {
        let result = try self.parseJSON(JSONAPIErrorExample.standart)
        
        XCTAssertNotNil(result.json)
        XCTAssertNil(result.error)
    }
}
