//
//  LimeAPIClientBroadcastsTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 09.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_requestBroadcasts_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<[Broadcast]>?
        
        self.sut.requestBroadcasts(channelId: 105, dateInterval: self.testDateInterval) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    var testDateInterval: LACDateInterval {
        let startDate = Date().addingTimeInterval(-8.days)
        let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
        return LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
    }
    
    func test_requestBroadcasts_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<[Broadcast]>?
        let data = try generateJSONData(JSONAPIObject<[Broadcast], Broadcast.Meta>.self, string: BroadcastExample)
        
        self.sut.requestBroadcasts(channelId: 105, dateInterval: self.testDateInterval) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded?.data)
        XCTAssertNil(completion?.error)
    }
}
