//
//  LimeAPIClientTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
import HTTPURLRequest
@testable import LimeAPIClient

class LimeAPIClientTests: XCTestCase {
    struct APICompletion<T> {
        let data: T?
        let error: Error?
    }
    
    var sut: LimeAPIClient!
    var baseUrl = "https://limehd.tv/"
    var url = URL(string: "https://limehd.tv/")!
    var session: MockURLSession!
    var queue: MockDispatchQueue!
    
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.queue = MockDispatchQueue()
        self.sut = LimeAPIClient(baseUrl: self.baseUrl, session: self.session, mainQueue: queue)
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
            let actualError = try XCTUnwrap(error as? URLRequestError)
            XCTAssertEqual(actualError, URLRequestError.emptyUrl)
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
            let actualError = try XCTUnwrap(error as? URLRequestError)
            XCTAssertEqual(actualError, URLRequestError.invalidUrl(url))
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    func test_httpError_callsCompletionWithFailure() throws {
        var completion: APICompletion<Session>?
        let expectedError = HTTPURLRequest.Error.emptyData
        
        self.sut.session { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(nil, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? HTTPURLRequest.Error)
        XCTAssertEqual(actualError, expectedError)
    }
    
    func response(_ statusCode: Int) throws -> HTTPURLResponse {
        let response = HTTPURLResponse(url: self.url, statusCode: statusCode)
        return try XCTUnwrap(response)
    }
    
    var response200: HTTPURLResponse? {
        try? self.response(200)
    }
    
    func test_dataTask_givenJSONAPIBaseError_callsCompletionWithFailure() throws {
        let result = try self.generateJSONAPIError(JSONAPIErrorExample.base)
        
        XCTAssertNotNil(result.completion)
        XCTAssertNil(result.completion?.data)
        let actualError = try XCTUnwrap(result.completion?.error as? APIError)
        XCTAssertEqual(actualError, result.expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    typealias APIErrorResult = (expectedError: APIError, completion: APICompletion<Session>?)
    
    func generateJSONAPIError(_ jsonAPIError: String) throws -> APIErrorResult {
        let data = try XCTUnwrap(jsonAPIError.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonAPIError = data.decoding(type: JSONAPIError.self, decoder: decoder).success!
        
        let response = try self.response(500)
        let apiError = APIError.jsonAPIError(response.localizedStatusCode, error: jsonAPIError)
        
        let completion = self.runSessionRequest(data, response)
        return (apiError, completion)
    }
    
    @discardableResult
    func runSessionRequest(_ data: Data?, _ response: HTTPURLResponse?) -> APICompletion<Session>? {
        var completion: APICompletion<Session>?
        self.sut.session { (result) in
            completion = self.callAPICompletion(result)
        }
        self.session.lastTask?.completionHandler(data, response, nil)
        return completion
    }
    
    func test_dataTask_givenJSONAPIStandartError_callsCompletionWithFailure() throws {
        let result = try self.generateJSONAPIError(JSONAPIErrorExample.standart)
        
        XCTAssertNotNil(result.completion)
        XCTAssertNil(result.completion?.data)
        let actualError = try XCTUnwrap(result.completion?.error as? APIError)
        XCTAssertEqual(actualError, result.expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_dataTask_givenStatusCodeError_callsCompletionWithFailure() throws {
        let data = Data()
        let message = String(decoding: data, as: UTF8.self)
        let response = try self.response(500)
        let expectedError = APIError.wrongStatusCode(response.localizedStatusCode, error: message)
        let completion = self.runSessionRequest(data, response)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        let actualError = try XCTUnwrap(completion?.error as? APIError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
}

// MARK: - Session Tests

extension LimeAPIClientTests {
    func test_session_wrongResponseData_callsCompletionWithFailure() {
        let completion = self.runSessionRequest(Data(), self.response200)
        
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
        let data = try generateJSONData(Session.self, string: SessionExample.correct)
        let completion = self.runSessionRequest(data.raw, self.response200)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
    
    typealias JSONData<T> = (raw: Data?, decoded: T?)
    
    func generateJSONData<T: Decodable>(_ type: T.Type, string: String) throws -> JSONData<T> {
        let rawData = try XCTUnwrap(string.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode(T.self, from: rawData)
            return (rawData, decodedData)
        } catch {
            print("\(Self.self).\(#function).Error.unableDecoding")
            print("-----------------------------------")
            print(String(decoding: rawData, as: UTF8.self))
            print("-----------------------------------")
        }
        
        return (rawData, nil)
    }
    
    func test_session_successfulSessionSetsDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample.correct)
        
        let configuration = LACConfiguration(appId: "TEST_ID", apiKey: "TEST_API", language: Device.language)
        LimeAPIClient.configuration = configuration
        XCTAssertNotNil(LimeAPIClient.configuration)
        
        self.sut.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
    }
    
    func test_session_emptyConfigurationNotSetsDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample.correct)
        
        self.sut.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
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
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
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
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data, data.decoded)
        XCTAssertNil(completion?.error)
    }
}

// MARK: - MockDispatchQueue

class MockDispatchQueue: Dispatchable {
    func async(execute work: @escaping () -> Void) { work() }
}
