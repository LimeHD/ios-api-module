//
//  LACStreamTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 22.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class LACStreamTests: XCTestCase {
    let streamId = 44
    
    func test_onlineEndpoint_runBeforeSession_throws() throws {
        let expectedError = LACStream.Error.sessionError
        
        LimeAPIClient.configuration = nil
        XCTAssertThrowsError(try LACStream.Online.endpoint(for: self.streamId))
        
        do {
            _ = try LACStream.Online.endpoint(for: self.streamId)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_onlineEndpoint_returnsCorrectValue() throws {
        let expectedPath = "https://api.iptv2021.com/v1/streams/\(self.streamId)/redirect"
        
        try self.runSession(with: SessionExample.correct)
        
        XCTAssertNoThrow(try LACStream.Online.endpoint(for: self.streamId))
        
        let actualPath = try LACStream.Online.endpoint(for: self.streamId)
        
        XCTAssertEqual(expectedPath, actualPath)
    }
    
    func test_onlineUrlAsset_runBeforeSession_throws() throws {
        let expectedError = LACStream.Error.sessionError
        
        LimeAPIClient.configuration = nil
        XCTAssertThrowsError(try LACStream.Online.urlAsset(for: self.streamId))
        
        do {
            _ = try LACStream.Online.urlAsset(for: self.streamId)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_onlineUrlAsset_invalidUrl_throws() throws {
        let endpointPath = "INVALID URL"
        let expectedError = LACStream.Error.invalidUrl(endpointPath)
        
        try self.runSession(with: SessionExample.failedEndpoint(endpointPath))
        
        XCTAssertNoThrow(try LACStream.Online.endpoint(for: self.streamId))
        XCTAssertThrowsError(try LACStream.Online.urlAsset(for: self.streamId))
        
        do {
            _ = try LACStream.Online.urlAsset(for: self.streamId)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func runSession(with session: String) throws {
        let baseUrl = "https://limehd.tv/"
        
        let configuration = LACConfiguration(appId: "TEST_ID", apiKey: "TEST_API", language: "ru")
        LimeAPIClient.configuration = configuration
        
        let data = try XCTUnwrap(session.data(using: .utf8))
        let session = MockURLSession()
        let queue = MockDispatchQueue()
        let apiClient = LimeAPIClient(baseUrl: baseUrl, session: session, mainQueue: queue)
        apiClient.session { (_) in }
        
        let url = try XCTUnwrap(URL(string: baseUrl))
        let response = HTTPURLResponse(url: url, statusCode: 200)
        session.lastTask?.completionHandler(data, response, nil)
    }
    
    func test_onlineUrlAsset_returnsCorrectValue() throws {
        try self.runSession(with: SessionExample.correct)
        
        XCTAssertNoThrow(try LACStream.Online.endpoint(for: self.streamId))
        XCTAssertNoThrow(try LACStream.Online.urlAsset(for: self.streamId))
        
        let asset = try LACStream.Online.urlAsset(for: self.streamId)
        let path = "https://api.iptv2021.com/v1/streams/\(self.streamId)/redirect"
        let url = try XCTUnwrap(URL(string: path))
        
        XCTAssertEqual(asset.url, url)
    }
    
    func test_onlineRequest_runBeforeSession_throws() throws {
        let expectedError = LACStream.Error.sessionError
        
        LimeAPIClient.configuration = nil
        XCTAssertThrowsError(try LACStream.Online.request(for: 44))
        
        do {
            _ = try LACStream.Online.request(for: 44)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_onlineRequest_returnsCorrectRequest() throws {
        try self.runSession(with: SessionExample.correct)
        let path = "https://api.iptv2021.com/v1/streams/\(self.streamId)/redirect"
        let expectedRequest = try URLRequest(path: path)
        
        XCTAssertNoThrow(try LACStream.Online.request(for: self.streamId))
        
        let actualRequest = try LACStream.Online.request(for: self.streamId)
        
        XCTAssertEqual(actualRequest, expectedRequest)
    }
    
    func test_archiveUrlAsset_runBeforeAPIClientInit_throws() throws {
        let expectedError = LACStream.Error.emptyBaseUrl
        
        LACStream.baseUrl = ""
        XCTAssertThrowsError(try LACStream.Archive.urlAsset(for: 1, start: 10, duration: 100))
        
        do {
            _ = try LACStream.Archive.urlAsset(for: 1, start: 10, duration: 100)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_archiveUrlAsset_returnsCorrectValue() throws {
        _ = LimeAPIClient(baseUrl: "https://limehd.tv/")
        
        let streamId = 1
        let start = 10
        let duration = 100
        XCTAssertNoThrow(try LACStream.Archive.urlAsset(for: streamId, start: start, duration: duration))
        
        let asset = try LACStream.Archive.urlAsset(for: streamId, start: start, duration: duration)
        let endPoint = EndPoint.Factory.archiveStream(for: streamId, start: start, duration: duration)
        let url = try XCTUnwrap(try URLRequest(baseUrl: LACStream.baseUrl, endPoint: endPoint).url)

        XCTAssertEqual(asset.url.baseURL, url.baseURL)
        XCTAssertEqual(asset.url.queryDictionary, url.queryDictionary)
    }
    
    func test_archiveUrlAssetFromBroadcast_emptyStartAt_throws() throws {
        let expectedError = LACStream.Error.emptyBroadcastStartAt
        
        _ = LimeAPIClient(baseUrl: "https://limehd.tv/")
        
        let broadcast = self.getBroadcast()
        
        XCTAssertThrowsError(try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast))
        
        do {
            _ = try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func getBroadcast(startAt: String = "", finishAt: String = "") -> Broadcast {
        let attributes = Broadcast.Attributes(title: "", detail: "", rating: nil, startAt: startAt, finishAt: finishAt)
        let broadcast = Broadcast(id: "", type: "", attributes: attributes)
        
        return broadcast
    }
    
    func test_archiveUrlAssetFromBroadcast_emptyDuration_throws() throws {
        let expectedError = LACStream.Error.emptyBroadcastDuration
        
        _ = LimeAPIClient(baseUrl: "https://limehd.tv/")
        
        let broadcast = self.getBroadcast(startAt: "2020-06-02T00:00:00+03:00")
        
        XCTAssertThrowsError(try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast))
        
        do {
            _ = try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast)
        } catch {
            let actualError = try XCTUnwrap(error as? LACStream.Error)
            XCTAssertEqual(actualError, expectedError)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_archiveUrlAssetFromBroadcast_returnsCorrectValue() throws {
        _ = LimeAPIClient(baseUrl: "https://limehd.tv/")
        
        let broadcast = self.getBroadcast(startAt: "2020-06-02T00:00:00+03:00", finishAt: "2020-06-02T15:00:00+03:00")
        XCTAssertNoThrow(try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast))
        
        let asset = try LACStream.Archive.urlAsset(for: 1, broadcast: broadcast)
        let start = try XCTUnwrap(broadcast.startAtUnix)
        let duration = try XCTUnwrap(broadcast.duration)
        let endPoint = EndPoint.Factory.archiveStream(for: 1, start: start, duration: duration)
        let url = try XCTUnwrap(try URLRequest(baseUrl: LACStream.baseUrl, endPoint: endPoint).url)

        XCTAssertEqual(asset.url.baseURL, url.baseURL)
        XCTAssertEqual(asset.url.queryDictionary, url.queryDictionary)
    }
}
