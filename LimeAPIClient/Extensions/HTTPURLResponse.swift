//
//  HTTPURLResponse.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var localizedStatusCode: String {
        let statusCode = self.statusCode
        let localizedString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        return "\(statusCode) - \(localizedString)"
    }
}
