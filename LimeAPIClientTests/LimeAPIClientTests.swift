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
    
    func test_request_emptyUrl_callsCompletionWithFailure() throws {
        let result = self.runRequest(String.self, url: "")
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        let actualError = try XCTUnwrap(result.error as? ApiError)
        XCTAssertEqual(actualError, ApiError.emptyUrl)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    typealias RequestResults<T: Decodable> = (calledCompletion: Bool, data: T?, error: Error?)
    
    func runRequest<T: Decodable>(_ type: T.Type, url: String) -> RequestResults<T> {
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
        }
        
        return (calledCompletion, receivedData, receivedError)
    }
    
    func test_request_inValidUrl_callsCompletionWithFailure() throws {
        let url = "]ч"
        
        let result = self.runRequest(String.self, url: url)
        
        XCTAssertTrue(result.calledCompletion)
        XCTAssertNil(result.data)
        let actualError = try XCTUnwrap(result.error as? ApiError)
        XCTAssertEqual(actualError, ApiError.invalidUrl(url))
        XCTAssertNotNil(actualError.localizedDescription)
    }
}
