//
//  DecodableTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 19.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class DecodableTests: XCTestCase {
    var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    override func tearDown() {
        self.decoder = nil
        super.tearDown()
    }
    
    func test_init_givenInvalidJSON_throws() throws {
        let data = try XCTUnwrap(JSONAPIErrorExample.incorrectData.data(using: .utf8))
        XCTAssertThrowsError(try JSONAPIError(decoding: data, decoder: self.decoder))
        
        var expectedError: Error? = nil
        do {
            _ = try self.decoder.decode(JSONAPIError.self, from: data)
        } catch {
            expectedError = error
        }
        
        var actualError: Error? = nil
        do {
            _ = try JSONAPIError(decoding: data, decoder: self.decoder)
        } catch {
            actualError = error
        }
        
        XCTAssertNotNil(actualError?.localizedDescription)
        XCTAssertNotNil(expectedError?.localizedDescription)
        XCTAssertEqual(actualError?.localizedDescription, expectedError?.localizedDescription)
    }
    
    func test_init_givenCorrectJSON_initilize() throws {
        let data = try XCTUnwrap(JSONAPIErrorExample.standart.data(using: .utf8))
        XCTAssertNoThrow(try JSONAPIError(decoding: data, decoder: self.decoder))
        
        let expectedJSONAPIError = try? self.decoder.decode(JSONAPIError.self, from: data)
        let actualJSONAPIError = try? JSONAPIError(decoding: data, decoder: self.decoder)
    
        XCTAssertNotNil(actualJSONAPIError)
        XCTAssertNotNil(expectedJSONAPIError)
        XCTAssertEqual(actualJSONAPIError, expectedJSONAPIError)
    }
}
