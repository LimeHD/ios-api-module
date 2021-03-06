//
//  LACImageTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 22.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import Networker
@testable import LimeAPIClient

extension LimeAPIClientTests {
    func test_getImage_wrongResponseData_callsCompletionWithFailure() throws {
        var completion: APICompletion<UIImage>?
        let expectedError = LimeAPIClient.Error.incorrectImageData
        
        LimeAPIClient.getImage(with: "IMAGE_URL") { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? LimeAPIClient.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getImage_givenStatusCodeError_callsCompletionWithFailure() throws {
        var completion: APICompletion<UIImage>?
        let data = Data()
        let response = try self.response(500)
        let dataResponse = DataResponse(data: data, response: response)
        let expectedError = HTTPURLRequest.Error.unsuccessfulHTTPStatusCode(dataResponse)
        LimeAPIClient.getImage(with: self.baseUrl) { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(data, response, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        let actualError = try XCTUnwrap(completion?.error as? HTTPURLRequest.Error)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getImage_wrongPath_callsCompletionWithFailure() throws {
        var completion: APICompletion<UIImage>?
        let expectedError = URLRequestError.invalidUrl("")
        
        LimeAPIClient.getImage(with: "") { (result) in
            completion = self.callAPICompletion(result)
        }
        
        self.session.lastTask?.completionHandler(Data(), self.response200, nil)
        
        XCTAssertNotNil(completion)
        XCTAssertNil(completion?.data)
        XCTAssertNotNil(completion?.error)
        let actualError = try XCTUnwrap(completion?.error as? URLRequestError)
        XCTAssertEqual(actualError, expectedError)
        XCTAssertNotNil(actualError.localizedDescription)
    }
    
    func test_getImage_correctResponseData_callsCompletionWithSuccess() throws {
        var completion: APICompletion<UIImage>?
        let image = try XCTUnwrap(UIImage(color: .black))
        let data = try XCTUnwrap(image.pngData())

        LimeAPIClient.getImage(with: "IMAGE_URL") { (result) in
            completion = self.callAPICompletion(result)
        }

        self.session.lastTask?.completionHandler(data, self.response200, nil)

        XCTAssertNotNil(completion)
        XCTAssertNotNil(completion?.data)
        XCTAssertEqual(completion?.data?.size, image.size)
        XCTAssertNil(completion?.error)
    }
}
