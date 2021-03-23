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
    
    func test_versionCode_createsCorrectValue() {
        let versions = ["1.7.3", "2.0.0", "1", "1.10.2"]
        let expectedVersions = ["10703", "20000", "10000", "11002"]
        
        let actualVersions = versions.map { LACApp.versionCode(from: $0) }
            
        XCTAssertEqual(actualVersions, expectedVersions)
    }
    

}
