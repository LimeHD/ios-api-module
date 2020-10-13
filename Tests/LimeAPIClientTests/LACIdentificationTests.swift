import XCTest
@testable import LimeAPIClient

class LACIdentificationTests: XCTestCase {
    var sut: LACIdentification!

    func test_init_setsCorrectValues() {
        let appId = "APP_ID"
        let apiKey = "API_KEY"
        self.sut = LACIdentification(appId: appId, apiKey: apiKey)
        
        XCTAssertEqual(self.sut.appId, appId)
        XCTAssertEqual(self.sut.apiKey, apiKey)
    }

}
