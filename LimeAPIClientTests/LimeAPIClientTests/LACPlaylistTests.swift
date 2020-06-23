//
//  LACPlaylistTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 22.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_getOnlinePlaylist_runBeforeSession_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let expectedError = LACStream.Error.sessionError
        
        self.sut.getOnlinePlaylist(for: 44) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? LACStream.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getOnlinePlaylist_givenStatusCodeError_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let data = Data()
        let response = try self.response(500)
        let expectedError =  HTTPError.wrongStatusCode(data, response)
        try self.runSessionToGetAPIValues()
        self.sut.getOnlinePlaylist(for: 44) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data, response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        let actualError = try XCTUnwrap(completion?.error as? HTTPError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getOnlinePlaylist_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<String>?
        let string = "TEST"
        let data = string.data(using: .utf8)
        try self.runSessionToGetAPIValues()
        self.sut.getOnlinePlaylist(for: 44) { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, string)
        XCTAssertNil(completion?.error)
    }
    
    func test_getArchivePlaylist_runWithEmptyBaseUrl_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let expectedError = URLRequestError.emptyUrl
        
        self.sut = LimeAPIClient(baseUrl: "", session: self.session, mainQueue: self.queue)
        self.sut.getArchivePlaylist(for: 44, startAt: 10, duration: 300) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? URLRequestError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }

    func test_getArchivePlaylist_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<String>?
        let string = "TEST"
        let data = string.data(using: .utf8)
        try self.runSessionToGetAPIValues()
        self.sut.getArchivePlaylist(for: 44, startAt: 10, duration: 300) { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, string)
        XCTAssertNil(completion?.error)
    }
}
