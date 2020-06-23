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
    func test_onlineUrlAsset_runBeforeSession_throws() throws {
        let expectedError = LACStream.Error.sessionError
        
        LimeAPIClient.configuration = nil
        XCTAssertThrowsError(try LACStream.Online.endpoint(for: 44))
        
        do {
            _ = try LACStream.Online.endpoint(for: 44)
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
        
        XCTAssertNoThrow(try LACStream.Online.endpoint(for: 44))
        XCTAssertThrowsError(try LACStream.Online.urlAsset(for: 44))
        
        do {
            _ = try LACStream.Online.urlAsset(for: 44)
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
        let streamId = 44
        try self.runSession(with: SessionExample.correct)
        
        XCTAssertNoThrow(try LACStream.Online.endpoint(for: streamId))
        XCTAssertNoThrow(try LACStream.Online.urlAsset(for: streamId))
        
        let asset = try LACStream.Online.urlAsset(for: streamId)
        let path = "https://api.iptv2021.com/v1/streams/\(streamId)/redirect"
        let url = try XCTUnwrap(URL(string: path))
        
        XCTAssertEqual(asset.url, url)
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
        let baseUrl = "https://limehd.tv/"
        let session = MockURLSession()
        let queue = MockDispatchQueue()
        _ = LimeAPIClient(baseUrl: baseUrl, session: session, mainQueue: queue)
        
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
}
