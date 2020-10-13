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
    
    var baseUrl = "https://limehd.tv/"
    var url = URL(string: "https://limehd.tv/")!
    var session: MockURLSession!
    var queue: MockDispatchQueue!
    
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.queue = MockDispatchQueue()
        let configuration = LACConfiguration(baseUrl: self.baseUrl, language: "ru", session: self.session, mainQueue: self.queue)
        LimeAPIClient.setConfiguration(configuration)
    }
    
    override func tearDown() {
        self.session = nil
        super.tearDown()
        LimeAPIClient.setIdentification(nil)
        LimeAPIClient.setConfiguration(nil)
    }
    
    func test_setIdentification_setsValue() {
        let appId = "APP_ID"
        let apiKey = "API_KEY"
        let identification = LACIdentification(appId: appId, apiKey: apiKey)
    
        LimeAPIClient.setIdentification(identification)
        
        XCTAssertNotNil(LimeAPIClient.identification)
        XCTAssertEqual(LimeAPIClient.identification, identification)
    }
    
    func test_setConfiguration_setsValue() {
        let configuration = LACConfiguration(baseUrl: self.baseUrl, language: Device.language)
        LimeAPIClient.setConfiguration(configuration)
        
        XCTAssertNotNil(LimeAPIClient.configuration)
        XCTAssertEqual(LimeAPIClient.configuration?.baseUrl, LACStream.baseUrl)
    }
    
    func test_beforeUse_sets_configuration() {
        let configuration = LACConfiguration(baseUrl: self.baseUrl, language: Device.language)
        LimeAPIClient.setConfiguration(configuration)
        
        XCTAssertNotNil(LimeAPIClient.configuration)
    }
    
    func test_request_emptyBaseUrl_callsCompletionWithFailure() {
        let configuration = LACConfiguration(baseUrl: "", language: "ru", session: self.session)
        LimeAPIClient.setConfiguration(configuration)
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
        
        LimeAPIClient.requestChannels() { (result) in
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
        let configuration = LACConfiguration(baseUrl: url, language: "ru", session: self.session)
        LimeAPIClient.setConfiguration(configuration)
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
        
        LimeAPIClient.session { (result) in
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
        LimeAPIClient.session { (result) in
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
        let identification = LACIdentification(appId: "APP_ID", apiKey: "API_KEY")
        LimeAPIClient.setIdentification(identification)
        let configuration = LACConfiguration(baseUrl: self.baseUrl, language: Device.language, session: self.session, mainQueue: self.queue)
        LimeAPIClient.setConfiguration(configuration)
        XCTAssertNotNil(LimeAPIClient.configuration)
        
        LimeAPIClient.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertFalse(defaultChannelGroupId.isEmpty)
    }
    
    func test_session_emptyConfigurationNotSetsDefaultChannelGroupId() throws {
        let data = try generateJSONData(Session.self, string: SessionExample.correct)
        LimeAPIClient.setConfiguration(nil)
        
        LimeAPIClient.session { (result) in }
        
        self.session.lastTask?.completionHandler(data.raw, self.response200, nil)
        
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        XCTAssertTrue(defaultChannelGroupId.isEmpty)
    }
}

// MARK: - Ping Tests

extension LimeAPIClientTests {
    func test_ping_wrongResponseData_callsCompletionWithFailure() {
        var completion: APICompletion<Ping>?
        
        LimeAPIClient.ping { (result) in
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
        
        LimeAPIClient.ping { (result) in
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
