//
//  LimeAPIClientChannelsTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_requestChannels_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<[Channel]> = (nil,  nil)
        
        self.sut.requestChannels { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_requestChannels_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<[Channel]> = (nil,  nil)
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        self.sut.requestChannels { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult.data)
        XCTAssertEqual(requestResult.data, data.decoded?.data)
        XCTAssertNil(requestResult.error)
    }
    
    func test_requestChannelsByGroupId_runBeforeSession_callsCompletionWithFailure() throws {
        var calledCompletion = false
        var requestResult: RequestResult<[Channel]> = (nil,  nil)
        let expectedError = APIError.unknownChannelsGroupId
        
        self.sut.requestChannelsByGroupId { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertTrue(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
        let actualError = try XCTUnwrap(requestResult.error as? APIError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_requestChannelsByGroupId_wrongResponseData_callsCompletionWithFailure() throws {
        var calledCompletion = false
        var requestResult: RequestResult<[Channel]> = (nil,  nil)
        
        try self.runSessionToSetDefaultChannelGroupId()
        
        self.sut.requestChannelsByGroupId { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
        let apiError = requestResult.error as? APIError
        XCTAssertNil(apiError)
    }
    
    func runSessionToSetDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample)
        
        let configuration = LACConfiguration(appId: "TEST_ID", apiKey: "TEST_API", language: Device.language)
        LimeAPIClient.configuration = configuration
        
        self.sut.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
    }
    
    func test_requestChannelsByGroupId_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<[Channel]> = (nil,  nil)
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        try self.runSessionToSetDefaultChannelGroupId()
        
        self.sut.requestChannelsByGroupId { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult.data)
        XCTAssertEqual(requestResult.data, data.decoded?.data)
        XCTAssertNil(requestResult.error)
    }
}

