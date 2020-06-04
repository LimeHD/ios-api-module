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
        var completion: APICompletion<[Channel]> = (data: nil, error: nil, isCalled: false)
        
        self.sut.requestChannels { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(completion.isCalled)
        XCTAssertNil(completion.data)
        XCTAssertNotNil(completion.error)
    }
    
    func test_requestChannels_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<[Channel]> = (data: nil, error: nil, isCalled: false)
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        self.sut.requestChannels { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(completion.isCalled)
        XCTAssertNotNil(completion.data)
        XCTAssertEqual(completion.data, data.decoded?.data)
        XCTAssertNil(completion.error)
    }
    
    func test_requestChannelsByGroupId_runBeforeSession_callsCompletionWithFailure() throws {
        var completion: APICompletion<[Channel]> = (data: nil, error: nil, isCalled: false)
        let expectedError = APIError.unknownChannelsGroupId
        
        self.sut.requestChannelsByGroupId { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertTrue(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(completion.isCalled)
        XCTAssertNil(completion.data)
        XCTAssertNotNil(completion.error)
        let actualError = try XCTUnwrap(completion.error as? APIError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_requestChannelsByGroupId_wrongResponseData_callsCompletionWithFailure() throws {
        var completion: APICompletion<[Channel]> = (data: nil, error: nil, isCalled: false)
        
        try self.runSessionToSetDefaultChannelGroupId()
        
        self.sut.requestChannelsByGroupId { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(completion.isCalled)
        XCTAssertNil(completion.data)
        XCTAssertNotNil(completion.error)
        let apiError = completion.error as? APIError
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
        var completion: APICompletion<[Channel]> = (data: nil, error: nil, isCalled: false)
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        try self.runSessionToSetDefaultChannelGroupId()
        
        self.sut.requestChannelsByGroupId { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertTrue(completion.isCalled)
        XCTAssertNotNil(completion.data)
        XCTAssertEqual(completion.data, data.decoded?.data)
        XCTAssertNil(completion.error)
    }
}

