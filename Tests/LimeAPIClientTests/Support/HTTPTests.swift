//
//  HTTPTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 02.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class HTTPTests: XCTestCase {
    var sut = HTTP.self

    func test_headersIsNotNil() {
        XCTAssertNotNil(self.sut.headers["Accept-Language"])
        XCTAssertNotNil(self.sut.headers["X-Platform"])
        XCTAssertNotNil(self.sut.headers["X-Device-Name"])
        XCTAssertNotNil(self.sut.headers["X-Device-Id"])
        XCTAssertNotNil(self.sut.headers["X-App-Id"])
        XCTAssertNotNil(self.sut.headers["X-App-Version"])
        XCTAssertNotNil(self.sut.headers["X-Access-Key"])
        XCTAssertNotNil(self.sut.headers["X-Session-Id"])
    }

    func test_headersIsCorrect() throws {
        try self.configureLimeAPIClient()
        
        XCTAssertNotNil(LimeAPIClient.configuration)
        let language = LimeAPIClient.configuration?.language ?? ""
        XCTAssertEqual(self.sut.headers["Accept-Language"], language)
        let platform = "ios"
        XCTAssertEqual(self.sut.headers["X-Platform"], platform)
        let deviceName = Device.name
        XCTAssertEqual(self.sut.headers["X-Device-Name"], deviceName)
        let deviceId = Device.id
        XCTAssertEqual(self.sut.headers["X-Device-Id"], deviceId)
        let appId = LimeAPIClient.identification?.appId ?? ""
        XCTAssertEqual(self.sut.headers["X-App-Id"], appId)
        let appVersion = LACApp.version
        XCTAssertEqual(self.sut.headers["X-App-Version"], appVersion)
        let key = LimeAPIClient.identification?.apiKey ?? ""
        XCTAssertEqual(self.sut.headers["X-Access-Key"], key)
        let sessionId = LimeAPIClient.identification?.sessionId ?? ""
        XCTAssertEqual(self.sut.headers["X-Session-Id"], sessionId)
    }
    
    func configureLimeAPIClient() throws {
        let identification = LACIdentification(appId: "APP_ID", apiKey: "API_KEY")
        LimeAPIClient.setIdentification(identification)
        let configuration = LACConfiguration(language: Device.language)
        LimeAPIClient.configuration = configuration
        let baseUrl = "https://limehd.tv/"
        let session = MockURLSession()
        let queue = MockDispatchQueue()
        let apiClient = LimeAPIClient(baseUrl: baseUrl, session: session, mainQueue: queue)
        apiClient.session { (_) in }
        let url = try XCTUnwrap(URL(string: baseUrl))
        let response = HTTPURLResponse(url: url, statusCode: 200)
        let data = try XCTUnwrap(SessionExample.correct.data(using: .utf8))
        session.lastTask?.completionHandler(data, response, nil)
    }
}
