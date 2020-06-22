//
//  EndPointTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class EndPointTests: XCTestCase {
    var sut: EndPoint!
    let bannerId = 68
    
    override func setUp() {
        super.setUp()
        let configuration = LACConfiguration(appId: "TEST", apiKey: "TEST_KEY", language: "zh-Hans_HK")
        LimeAPIClient.configuration = configuration
    }
    
    override func tearDown() {
        LimeAPIClient.configuration = nil
        super.tearDown()
    }
    
    func test_testChannels_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Channels.test()
        
        XCTAssertEqual(self.sut.path, "v1/channels/test")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.jsonAPI)
        XCTAssertEqual(self.sut.parameters.url["locale"], LimeAPIClient.configuration?.languageDesignator ?? "")
    }
    
    func test_allChannels_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Channels.all()
        
        XCTAssertEqual(self.sut.path, "v1/channels")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.jsonAPI)
        XCTAssertEqual(self.sut.parameters.url["locale"], LimeAPIClient.configuration?.languageDesignator ?? "")
    }
    
    func test_channelsByGroupId_creatsCorrectEndPoint() {
        let defaultChannelGroupId = "105"
        self.sut = EndPoint.Factory.Channels.byGroupId(defaultChannelGroupId)
        
        XCTAssertEqual(self.sut.path, "v1/channels/by_group/\(defaultChannelGroupId)")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.jsonAPI)
        XCTAssertEqual(self.sut.parameters.url["locale"], LimeAPIClient.configuration?.languageDesignator ?? "")
    }
    
    func test_broadcasts_creatsCorrectEndPoint() {
        let channelId = 105
        let start = "start"
        let end = "end"
        let timeZone = "timeZone"
        self.sut = EndPoint.Factory.broadcasts(channelId: channelId, start: start, end: end, timeZone: timeZone)
        
        let urlParameters = [
            "channel_id" : channelId.string,
            "start_at" : start,
            "finish_at" : end,
            "time_zone" : timeZone,
            "locale" : LimeAPIClient.configuration?.languageDesignator ?? ""
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        
        XCTAssertEqual(self.sut.path, "v1/broadcasts")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.jsonAPI)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_pingWithEmptyKey_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.ping(key: "")
        let parameters = EndPoint.Parameters(url: [:])
        
        XCTAssertEqual(self.sut.path, "v1/ping")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_pingWithKey_creatsCorrectEndPoint() {
        let key = "TEST"
        self.sut = EndPoint.Factory.ping(key: key)
        let parameters = EndPoint.Parameters(url: ["key" : key.encoding(with: .rfc3986Allowed)])
        
        XCTAssertEqual(self.sut.path, "v1/ping")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_findBanner_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Banner.find()
        
        XCTAssertEqual(self.sut.path, "v1/banners/recommended/\(EndPoint.Factory.Banner.Request.find.rawValue)")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.parameters, self.bannerParameters)
    }
    
    var bannerParameters: EndPoint.Parameters {
        let urlParameters = [
            "device_id" : Device.id,
            "app_id" : LimeAPIClient.configuration?.appId ?? "",
            "platform" : "ios"
        ]
        return EndPoint.Parameters(url: urlParameters)
    }
    
    func test_nextBanner_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Banner.next()
        
        XCTAssertEqual(self.sut.path, "v1/banners/recommended/\(EndPoint.Factory.Banner.Request.next.rawValue)")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.parameters, self.bannerParameters)
    }
    
    func test_deleteBannerBan_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Banner.deleteBan(bannerId)
        let parameters = EndPoint.Parameters(url: ["device_id" : Device.id])
        
        XCTAssertEqual(self.sut.path, "v1/banners/\(self.bannerId)/ban")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.httpMethod, HTTP.Method.delete)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_banBanner_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Banner.ban(bannerId)
        let parameters = EndPoint.Parameters(body: ["device_id" : Device.id])
        
        XCTAssertEqual(self.sut.path, "v1/banners/\(self.bannerId)/ban")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.httpMethod, HTTP.Method.post)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_bannerInfo_creatsCorrectEndPoint() {
        self.sut = EndPoint.Factory.Banner.info(bannerId)
        let parameters = EndPoint.Parameters(url: ["device_id" : Device.id])
        
        XCTAssertEqual(self.sut.path, "v1/banners/\(self.bannerId)")
        XCTAssertEqual(self.sut.acceptHeader, HTTP.Header.Accept.json)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
    
    func test_archiveStream_creatsCorrectEndPoint() {
        let streamId = 1
        let start = 10
        let duration = 100
        self.sut = EndPoint.Factory.archiveStream(for: streamId, start: start, duration: duration)
        let urlParameters = [
            "id" : streamId.string,
            "start_at" : start.string,
            "duration" : duration.string
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        
        XCTAssertEqual(self.sut.path, "v1/streams/\(streamId)/archive_redirect")
        XCTAssertTrue(self.sut.acceptHeader.isEmpty)
        XCTAssertEqual(self.sut.parameters, parameters)
    }
}
