//
//  LimeAPIClientTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class LimeAPIClientTests: XCTestCase {
    var sut: LimeAPIClient!
    var baseUrl = "https://limehd.tv/"
    var session: MockURLSession!
    
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.sut = LimeAPIClient(baseUrl: self.baseUrl, session: self.session)
    }
    
    override func tearDown() {
        self.session = nil
        self.sut = nil
        super.tearDown()
    }
    
    func test_beforeUse_sets_configuration() {
        let configuration = LACConfiguration(appId: "TEST_ID", apiKey: "TEST_API", language: Device.language)
        LimeAPIClient.configuration = configuration
        XCTAssertNotNil(LimeAPIClient.configuration)
    }
    
    func test_init_sets_baseUrl() {
        XCTAssertEqual(self.sut.baseUrl, self.baseUrl)
    }
    
    func test_init_sets_session() {
        XCTAssertEqual(self.sut.session, self.session)
    }
    
    func test_request_emptyBaseUrl_callsCompletionWithFailure() {
        self.sut = LimeAPIClient(baseUrl: "", session: self.session)
        self.runRequestChannels { (calledCompletion, data, error) in
            XCTAssertTrue(calledCompletion)
            XCTAssertNil(data)
            let actualError = try XCTUnwrap(error as? LACParametersError)
            XCTAssertEqual(actualError, LACParametersError.emptyUrl)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    typealias RequestResults<T: Decodable> = (_ calledCompletion: Bool, _ data: T?, _ error: Error?) throws -> Void
    
    func runRequestChannels(comletion: @escaping RequestResults<[Channel]>) {
        var calledCompletion = false
        var receivedChannels: [Channel]? = nil
        var receivedError: Error? = nil
        
        self.sut.requestChannels() { (result) in
            calledCompletion = true
            
            switch result {
            case .success(let data):
                receivedChannels = data
            case .failure(let error):
                receivedError = error
            }
            
            try? comletion(calledCompletion, receivedChannels, receivedError)
        }
    }
    
    func test_request_invalidBaseUrl_callsCompletionWithFailure() {
        let url = "]ч"
        self.sut = LimeAPIClient(baseUrl: url, session: self.session)
        self.runRequestChannels { (calledCompletion, data, error) in
            XCTAssertTrue(calledCompletion)
            XCTAssertNil(data)
            let actualError = try XCTUnwrap(error as? LACParametersError)
            XCTAssertEqual(actualError, LACParametersError.invalidUrl(url))
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
}
