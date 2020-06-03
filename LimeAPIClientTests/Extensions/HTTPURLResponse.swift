//
//  HTTPURLResponse.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 03.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    convenience init?(url: URL, statusCode: Int) {
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
