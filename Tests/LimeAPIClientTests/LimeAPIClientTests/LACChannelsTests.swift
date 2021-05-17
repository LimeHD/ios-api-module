//
//  LACChannelsTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_requestChannels_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<[Channel]>?
        
        LimeAPIClient.requestChannels { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_requestChannels_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<[Channel]>?
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        LimeAPIClient.requestChannels { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded?.data)
        XCTAssertNil(completion?.error)
    }
    
    func test_requestChannelsByGroupId_runBeforeSession_callsCompletionWithFailure() throws {
        var completion: APICompletion<[Channel]>?
        let expectedError = LimeAPIClient.APIError.unknownChannelsGroupId
        
        LimeAPIClient.requestChannelsByGroupId { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertTrue(defaultChannelGroupId.isEmpty)
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? LimeAPIClient.APIError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_requestChannelsByGroupId_wrongResponseData_callsCompletionWithFailure() throws {
        var completion: APICompletion<[Channel]>?
        
        try self.runSessionToGetAPIValues()
        
        LimeAPIClient.requestChannelsByGroupId { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let apiError = completion?.error as? LimeAPIClient.APIError
        XCTAssertNil(apiError)
    }
    
    func runSessionToGetAPIValues() throws {
        let data = try generateJSONData(Session.self, string: SessionExample.correct)
        let identification = LACIdentification(appId: "APP_ID", apiKey: "API_KEY")
        LimeAPIClient.setIdentification(identification)
        let configuration = LACConfiguration(baseUrl: self.baseUrl, language: Device.language, session: self.session, mainQueue: self.queue)
        LimeAPIClient.setConfiguration(configuration)
        
        self.runSessionRequest(data.raw, self.response200)
    }
    
    func test_requestChannelsByGroupId_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<[Channel]>?
        let data = try generateJSONData(JSONAPIObject<[Channel], String>.self, string: ChannelExample)
        
        try self.runSessionToGetAPIValues()
        
        let cacheKey = "test"
        let timeZone = TimeZone(secondsFromGMT: 3.hours)
        let timeZonePicker = LACTimeZonePicker.previous
        LimeAPIClient.requestChannelsByGroupId(cacheKey: cacheKey, timeZone: timeZone, timeZonePicker: timeZonePicker) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded?.data)
        XCTAssertNil(completion?.error)
    }
}

