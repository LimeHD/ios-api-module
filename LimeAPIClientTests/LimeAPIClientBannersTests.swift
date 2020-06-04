//
//  LimeAPIClientBannersTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_findBanner_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice> = (nil,  nil)
        
        self.sut.findBanner { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_findBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice> = (nil,  nil)
        let data = try generateJSONData(BannerAndDevice.self, string: BannerAndDeviceExample)
        
        self.sut.findBanner { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult)
        XCTAssertEqual(requestResult.data, data.decoded)
        XCTAssertNil(requestResult.error)
    }
    
    func test_nextBanner_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice.Banner> = (nil,  nil)
        
        self.sut.nextBanner { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_nextBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice.Banner> = (nil,  nil)
        let data = try generateJSONData(BannerAndDevice.Banner.self, string: BannerExample)
        
        self.sut.nextBanner { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult)
        XCTAssertEqual(requestResult.data, data.decoded)
        XCTAssertNil(requestResult.error)
    }
    
    func test_deleteBanFromBanner_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<BanBanner> = (nil,  nil)
        
        self.sut.deleteBanFromBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_deleteBanFromBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<BanBanner> = (nil,  nil)
        let data = try generateJSONData(BanBanner.self, string: BanBannerExample)
        
        self.sut.deleteBanFromBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult)
        XCTAssertEqual(requestResult.data, data.decoded)
        XCTAssertNil(requestResult.error)
    }
    
    func test_banBanner_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<BanBanner> = (nil,  nil)
        
        self.sut.banBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_banBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<BanBanner> = (nil,  nil)
        let data = try generateJSONData(BanBanner.self, string: BanBannerExample)
        
        self.sut.banBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult)
        XCTAssertEqual(requestResult.data, data.decoded)
        XCTAssertNil(requestResult.error)
    }
    
    func test_getBanner_wrongResponseData_callsCompletionWithFailure() {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice.Banner> = (nil,  nil)
        
        self.sut.getBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNil(requestResult.data)
        XCTAssertNotNil(requestResult.error)
    }
    
    func test_getBanner_correctResponseData_callsCompletionWithSuccess() throws {
        var calledCompletion = false
        var requestResult: RequestResult<BannerAndDevice.Banner> = (nil,  nil)
        let data = try generateJSONData(BannerAndDevice.Banner.self, string: BannerExample)
        
        self.sut.getBanner(bannerId: 68) { (result) in
            calledCompletion = true
            requestResult = self.getRequestResult(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertTrue(calledCompletion)
        XCTAssertNotNil(requestResult)
        XCTAssertEqual(requestResult.data, data.decoded)
        XCTAssertNil(requestResult.error)
    }
}
