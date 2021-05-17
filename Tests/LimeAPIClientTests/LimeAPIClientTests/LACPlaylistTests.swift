//
//  LACPlaylistTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 22.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import HTTPURLRequest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_getOnlinePlaylist_runBeforeSession_callsCompletionWithFailure() throws {
        var completion: APICompletion<String>?
        let expectedError = LACStream.Error.sessionError
        
        LimeAPIClient.getOnlinePlaylist(for: 44) { (result) in
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
        let dataResponse = DataResponse(data: data, response: response)
        let expectedError = HTTPURLRequest.Error.unsuccessfulHTTPStatusCode(dataResponse)
        try self.runSessionToGetAPIValues()
        LimeAPIClient.getOnlinePlaylist(for: 44) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data, response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = completion?.error as? HTTPURLRequest.Error
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError?.localizedDescription)
    }
    
    func test_getOnlinePlaylist_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<String>?
        let string = "TEST"
        let data = string.data(using: .utf8)
        try self.runSessionToGetAPIValues()
        LimeAPIClient.getOnlinePlaylist(for: 44) { (result) in
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
        
        let configiration = LACConfiguration(baseUrl: "", language: "ru", session: self.session, mainQueue: self.queue)
        LimeAPIClient.setConfiguration(configiration)
        LimeAPIClient.getArchivePlaylist(for: 44, startAt: 10, duration: 300) { (result) in
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

        LimeAPIClient.getArchivePlaylist(for: 44, startAt: 10, duration: 300) { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, string)
        XCTAssertNil(completion?.error)
    }
    
    func test_getArchivePlaylistFromBroadcast_emptyStartAt_callsCompletionWithFailure() throws {
        let expectedError = LimeAPIClient.Error.emptyBroadcastStartAt
        let completion = self.runGetArchivePlaylistFromBroadcast()

        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? LimeAPIClient.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func runGetArchivePlaylistFromBroadcast(startAt: String = "", finishAt: String = "", data: Data = Data()) -> APICompletion<String>? {
        var completion: APICompletion<String>?
        let attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: startAt, finishAt: finishAt)
        let broadcast = Broadcast(id: "", type: "", attributes: attributes)
        
        LimeAPIClient.getArchivePlaylist(for: 44, broadcast: broadcast) { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)
        return completion
    }
    
    func test_getArchivePlaylistFromBroadcast_emptyDuration_callsCompletionWithFailure() throws {
        let expectedError = LimeAPIClient.Error.emptyBroadcastDuration
        let completion = self.runGetArchivePlaylistFromBroadcast(startAt: "2020-06-02T00:00:00+03:00")

        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? LimeAPIClient.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getArchivePlaylistFromBroadcast_correctResponseData_callsCompletionWithSuccess() throws {
        let string = "TEST"
        let data = try XCTUnwrap(string.data(using: .utf8))

        let completion = self.runGetArchivePlaylistFromBroadcast(startAt: "2020-06-02T00:00:00+03:00", finishAt: "2020-06-02T15:00:00+03:00", data: data)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, string)
        XCTAssertNil(completion?.error)
    }
}

