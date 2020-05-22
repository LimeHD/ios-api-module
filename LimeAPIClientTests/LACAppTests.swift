//
//  LACAppTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 21.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class LACAppTests: XCTestCase {

    func test_bundleIdIsCorrect() {
        let expectedId = Bundle.main.bundleIdentifier ?? ""
        XCTAssertFalse(expectedId.isEmpty)
        XCTAssertEqual(LACApp.id, expectedId)
    }
    
    func test_versionIsCorrect() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let expectedVersion = version ?? ""
        XCTAssertEqual(LACApp.version, expectedVersion)
    }

}
