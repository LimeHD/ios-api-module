//
//  LACDeepClicksTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 11.08.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_deepClicks_incorrectBaseUrl_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let expectedError = URLRequestError.emptyUrl
        
        self.sut = LimeAPIClient(baseUrl: "", session: self.session, mainQueue: queue)
        self.sut.deepClicks(query: "Test query", path: "Test path") { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(nil, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? URLRequestError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_deepClicks_emptyData_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let expectedError = HTTPClient.Error.emptyData
        
        self.sut.deepClicks(query: "Test query", path: "Test path") { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(nil, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? HTTPClient.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_deepClicks_givenStatusCodeError_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let data = Data()
        let response = try self.response(500)
        let message = String(decoding: data, as: UTF8.self)
        let expectedError = APIError.wrongStatusCode(response.localizedStatusCode, error: message)
        self.sut.deepClicks(query: "Test query", path: "Test path") { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data, response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? APIError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_deepClicks_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<String>?
        let message = "Test"
        let data = try XCTUnwrap(message.data(using: .utf8))

        self.sut.deepClicks(query: "Test query", path: "Test path") { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, message)
        XCTAssertNil(completion?.error)
    }
}