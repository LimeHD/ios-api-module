//
//  LACBannersTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_findBanner_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<BannerAndDevice>?
        
        LimeAPIClient.findBanner { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_findBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<BannerAndDevice>?
        let data = try generateJSONData(BannerAndDevice.self, string: BannerAndDeviceExample)
        
        LimeAPIClient.findBanner { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    func test_nextBanner_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<BannerAndDevice.Banner>?
        
        LimeAPIClient.nextBanner { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_nextBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<BannerAndDevice.Banner>?
        let data = try generateJSONData(BannerAndDevice.Banner.self, string: BannerExample)
        
        LimeAPIClient.nextBanner { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    func test_deleteBanFromBanner_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<BanBanner>?
        
        LimeAPIClient.deleteBanFromBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_deleteBanFromBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<BanBanner>?
        let data = try generateJSONData(BanBanner.self, string: BanBannerExample)
        
        LimeAPIClient.deleteBanFromBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    func test_banBanner_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<BanBanner>?
        
        LimeAPIClient.banBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_banBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<BanBanner>?
        let data = try generateJSONData(BanBanner.self, string: BanBannerExample)
        
        LimeAPIClient.banBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    func test_getBanner_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<BannerAndDevice.Banner>?
        
        LimeAPIClient.getBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_getBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<BannerAndDevice.Banner>?
        let data = try generateJSONData(BannerAndDevice.Banner.self, string: BannerExample)
        
        LimeAPIClient.getBanner(bannerId: 68) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
}
