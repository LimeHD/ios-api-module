//
//  LACRefarralTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 28.08.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_referral_setsXToken() {
        let xToken = "xToken"
        
        LimeAPIClient.referral(xToken: xToken) { (_) in }
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertEqual(LimeAPIClient.xToken, xToken)
        XCTAssertNotNil(HTTP.headers["X-Token"])
        XCTAssertEqual(HTTP.headers["X-Token"], xToken)
    }
    
    func test_referral_wrongResponseData_callsCompletionWithFailure() {
        let xToken = "xToken"
        var completion: APICompletion<Referral>?
        
        LimeAPIClient.referral(xToken: xToken) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_referral_correctResponseData_callsCompletionWithSuccess() throws {
        let xToken = "xToken"
        var completion: APICompletion<Referral>?
        let data = try generateJSONData(Referral.self, string: ReferralExample)
        
        LimeAPIClient.referral(xToken: xToken) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
}

