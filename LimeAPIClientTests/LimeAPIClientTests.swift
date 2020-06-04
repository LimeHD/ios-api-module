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
    struct APICompletion<T> {
        let data: T?
        let error: Error?
    }
    
    var sut: LimeAPIClient!
    var baseUrl = "https://limehd.tv/"
    var session: MockURLSession!
    var queue: MockDispatchQueue!
    let response = HTTPURLResponse(url: URL(string: "https://limehd.tv/")!, statusCode: 200)
    
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.queue = MockDispatchQueue()
        self.sut = LimeAPIClient(baseUrl: self.baseUrl, session: self.session, mainQueue: queue, backgroundQueue: queue)
    }
    
    override func tearDown() {
        self.session = nil
        self.sut = nil
        super.tearDown()
        LimeAPIClient.configuration = nil
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
            let actualError = try XCTUnwrap(error as? URLParametersError)
            XCTAssertEqual(actualError, URLParametersError.emptyUrl)
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
            let actualError = try XCTUnwrap(error as? URLParametersError)
            XCTAssertEqual(actualError, URLParametersError.invalidUrl(url))
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_httpError_callsCompletionWithFailure() throws {
        var completion: APICompletion<Session>?
        let expectedError = HTTPError.emptyData
        
        self.sut.session { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(nil, self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? HTTPError)
        XCTAssertEqual(actualError, expectedError)
    }
}

// MARK: - Session Tests

extension LimeAPIClientTests {
    func test_session_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<Session>?
        
        self.sut.session { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func callAPICompletion<T>(_ result: Result<T, Error>) -> APICompletion<T> {
        switch result {
        case .success(let data):
            return APICompletion(data: data, error: nil)
        case .failure(let error):
            return APICompletion(data: nil, error: error)
        }
    }
    
    func test_session_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<Session>?
        let data = try generateJSONData(Session.self, string: SessionExample)
        
        self.sut.session { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    typealias JSONData<T> = (raw: Data?, decoded: T?)
    
    func generateJSONData<T: Decodable>(_ type: T.Type, string: String) throws -> JSONData<T> {
        let data = try XCTUnwrap(string.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
        let jsonAPIError = try decoder.decode(T.self, from: data)
            return (data, jsonAPIError)
        } catch {
            print("\(Self.self).\(#function).Error.unableDecoding")
            print("-----------------------------------")
            print(String(decoding: data, as: UTF8.self))
            print("-----------------------------------")
        }
        
        return (data, nil)
    }
    
    func test_session_successfulSessionSetsDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample)
        
        let configuration = LACConfiguration(appId: "TEST_ID", apiKey: "TEST_API", language: Device.language)
        LimeAPIClient.configuration = configuration
        XCTAssertNotNil(LimeAPIClient.configuration)
        
        self.sut.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
    }
    
    func test_session_emptyConfigurationNotSetsDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample)
        
        self.sut.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertTrue(defaultChannelGroupId.isEmpty)
    }
}

// MARK: - Ping Tests

extension LimeAPIClientTests {
    func test_ping_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<Ping>?
        
        self.sut.ping { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
    }
    
    func test_ping_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<Ping>?
        let data = try generateJSONData(Ping.self, string: PingExample)
        
        self.sut.ping { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
}

// MARK: - Broadcasts Tests

extension LimeAPIClientTests {
    func test_requestBroadcasts_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<[Broadcast]>?
        
        self.sut.requestBroadcasts(channelId: 105, dateInterval: self.testDateInterval) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response, nil)
        
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
        
        self.session.lastTask?.completionHandler(data.raw, self.response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded?.data)
        XCTAssertNil(completion?.error)
    }
}

// MARK: - MockDispatchQueue

class MockDispatchQueue: Dispatchable {
    func async(execute work: @escaping () -> Void) { work() }
}
