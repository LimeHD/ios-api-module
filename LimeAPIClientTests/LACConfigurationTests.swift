//
//  LACConfigurationTests.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 09.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import XCTest
@testable import LimeAPIClient

class LACConfigurationTests: XCTestCase {
    var sut: LACConfiguration!

    func test_languageDesignator_fullLanguage_createsCorrectValue() {
        let languageDesignator = "zh"
        let scriptDesignator = "Hans"
        let regionDesignator = "HK"
        let language = "\(languageDesignator)-\(scriptDesignator)_\(regionDesignator)"
        self.sut = LACConfiguration(appId: "", apiKey: "", language: language)
        
        XCTAssertEqual(self.sut.languageDesignator, languageDesignator)
    }
    
    func test_languageDesignator_LanguageWithDesignator_createsCorrectValue() {
        let languageDesignator = "ru"
        self.sut = LACConfiguration(appId: "", apiKey: "", language: languageDesignator)
        
        XCTAssertEqual(self.sut.languageDesignator, languageDesignator)
    }
    
    func test_languageDesignator_emptyLanguage_createsEmptyValue() {
        self.sut = LACConfiguration(appId: "", apiKey: "", language: "")
        
        XCTAssertTrue(self.sut.languageDesignator.isEmpty)
    }

}
