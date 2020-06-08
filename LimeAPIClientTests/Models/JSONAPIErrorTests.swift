//
//  JSONAPIErrorTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 08.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class JSONAPIErrorTests: XCTestCase {
    struct JSONAPIErrorData {
        let raw: Data
        let decoded: JSONAPIError
    }

    func test_decodingInit_givenInvalidDataThrows() {
        XCTAssertThrowsError(try JSONAPIError(decoding: Data()))
    }
    
    func test_decodingInit_givenJSONAPIBaseError_createsCorrectJSONAPIError() throws {
        let data = try self.generateJSONAPIError(JSONAPIErrorExample.base)
        
        XCTAssertNoThrow(try JSONAPIError(decoding: data.raw))
        let jsonAPIError = try JSONAPIError(decoding: data.raw)
        
        XCTAssertEqual(jsonAPIError, data.decoded)
    }
    
    func generateJSONAPIError(_ string: String) throws -> JSONAPIErrorData {
        let data = try XCTUnwrap(string.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonAPIError = try decoder.decode(JSONAPIError.self, from: data)
        
        return JSONAPIErrorData(raw: data, decoded: jsonAPIError)
    }
    
    func test_decodingInit_givenJSONAPIStandartError_createsCorrectJSONAPIError() throws {
        let data = try self.generateJSONAPIError(JSONAPIErrorExample.standart)
        
        XCTAssertNoThrow(try JSONAPIError(decoding: data.raw))
        let jsonAPIError = try JSONAPIError(decoding: data.raw)
        
        XCTAssertEqual(jsonAPIError, data.decoded)
    }
}
