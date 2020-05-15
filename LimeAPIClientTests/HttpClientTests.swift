//
//  HttpClientTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class HttpClientTests: XCTestCase {
    var sut: HttpClient!
    var session: MockURLSession!
    var url: URL {
        let path = "https://limehd.tv/"
        guard let url = URL(string: path) else {
            fatalError("Error: \(Self.self).\(#function) invalid url: \(path)")
        }
        return url
    }
    var request: URLRequest!
    
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.sut = HttpClient(self.session)
        self.request = URLRequest(url: self.url)
    }
    
    override func tearDown() {
        self.request = nil
        self.session = nil
        self.sut = nil
        super.tearDown()
    }
    
    func test_init_sets_session() {
        XCTAssertEqual(self.sut.session, session)
    }
    
    func test_getJSON_inValidUrl_callsCompletionWithFailure() {
        self.request.url = nil
        self.sut.getJSON(with: request) { _ in }
        
        let result = self.runGetJSONWith()
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        XCTAssertNotNil(result.error)
    }
    
    func test_getJSON_callsExpectedRequest() {
        self.sut.getJSON(with: self.request) { _ in }
        
        XCTAssertEqual(self.session.lastRequest, self.request)
    }
    
    func test_getJSON_callsResumeOnTask() {
        self.sut.getJSON(with: self.request) { _ in }
    
        XCTAssertTrue(self.session.lastTask?.calledResume ?? false)
    }
    
    func test_getJSON_givenError_callsCompletionWithFailure() throws {
        let expectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        
        let result = self.runGetJSONWith(self.response(200), expectedError)
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        
        let actualError = try XCTUnwrap(result.error as NSError?)
        XCTAssertEqual(actualError, expectedError)
    }
    
    typealias getJSONResults = (calledCompletion: Bool, data: (Data, String)?, error: Error?)
    
    func runGetJSONWith(data: Data? = nil, _ response: HTTPURLResponse? = nil, _ error: Error? = nil) -> getJSONResults {
        var calledCompletion = false
        var receivedData: (Data, String)? = nil
        var receivedError: Error? = nil
        
        self.sut.getJSON(with: self.request) { (result) in
            calledCompletion = true
            
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
        }
        
        self.session.lastTask?.completionHandler(data, response, error)
        
        return (calledCompletion, receivedData, receivedError)
    }
    
    func response(_ statusCode: Int?) -> HTTPURLResponse? {
        guard let statusCode = statusCode else { return nil }
        return HTTPURLResponse(url: self.url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
    
    func test_getJSON_emptyData_callsCompletionWithFailure() throws {
        let result = self.runGetJSONWith(self.response(200))
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        let actualError = try XCTUnwrap(result.error as? HttpError)
        XCTAssertEqual(actualError, HttpError.emptyData)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getJSON_unknownResponse_callsCompletionWithFailure() throws {
        let result = self.runGetJSONWith(data: Data())
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        let actualError = try XCTUnwrap(result.error as? HttpError)
        XCTAssertEqual(actualError, HttpError.unknownResponse)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getJSON_givenResponseStatusCode500_callsCompletionWithFailure() throws {
        let response = self.response(500)
        let unwrappedResponse = try XCTUnwrap(response)
        let expectedError = HttpError.wrongStatusCode(unwrappedResponse.localizedStatusCode)
        
        let result = self.runGetJSONWith(data: Data(), response)
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        let actualError = try XCTUnwrap(result.error as? HttpError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getJSON_givenDataAndSuccessResponseStatusCode_callsCompletionWithSuccess() throws {
        let result = self.runGetJSONWith(data: Data(), self.response(200))
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNotNil(result.data)
        XCTAssertNil(result.error)
    }
}

//MARK: - Mock Classes

typealias mockCompletion = (Data?, URLResponse?, Error?) -> Void

class MockURLSession: URLSession {
    private (set) var lastRequest: URLRequest?
    private (set) var lastTask: MockURLSessionDataTask?
    
    override init() { }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping mockCompletion) -> URLSessionDataTask {
        self.lastRequest = request
        let lastTask = MockURLSessionDataTask(completionHandler: completionHandler, request: request)
        self.lastTask = lastTask
        
        return lastTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: mockCompletion
    var request: URLRequest
    var calledResume = false
    
    init(completionHandler: @escaping mockCompletion, request: URLRequest) {
        self.completionHandler = completionHandler
        self.request = request
    }

    override func resume() {
        self.calledResume = true
    }
}
