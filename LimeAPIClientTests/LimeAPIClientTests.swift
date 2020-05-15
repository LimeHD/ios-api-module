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
    var sut = LimeAPIClient.self
    
    func test_request_emptyUrl_callsCompletionWithFailure() {
        self.runRequest(String.self, url: "") { (calledCompletion, data, error) in
            XCTAssertTrue(calledCompletion)
            XCTAssertNil(data)
            let actualError = try XCTUnwrap(error as? ApiError)
            XCTAssertEqual(actualError, ApiError.emptyUrl)
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
    
    typealias RequestResults<T: Decodable> = (_ calledCompletion: Bool, _ data: T?, _ error: Error?) throws -> Void
    
    func runRequest<T: Decodable>(_ type: T.Type, url: String, comletion: @escaping RequestResults<T>) {
        var calledCompletion = false
        var receivedData: T? = nil
        var receivedError: Error? = nil
        
        self.sut.request(T.self, url: url, endPoint: .testChannels) { (result) in
            calledCompletion = true
            
            switch result {
            case .success(let data):
                receivedData = data
            case .failure(let error):
                receivedError = error
            }
            
            try? comletion(calledCompletion, receivedData, receivedError)
        }
    }
    
    func test_request_inValidUrl_callsCompletionWithFailure() {
        let url = "]ч"
        self.runRequest(String.self, url: url) { (calledCompletion, data, error) in
            XCTAssertTrue(calledCompletion)
            XCTAssertNil(data)
            let actualError = try XCTUnwrap(error as? ApiError)
            XCTAssertEqual(actualError, ApiError.invalidUrl(url))
            XCTAssertNotNil(actualError.localizedDescription)
        }
    }
}
