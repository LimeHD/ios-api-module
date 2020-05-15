//
//  EndPoint.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public enum EndPoint {
    case testChannels
}

extension EndPoint {
    var httpMethod: String {
        switch self {
        case .testChannels:
            return HTTP.Method.get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .testChannels:
            return HTTP.headers(language: .ru, accept: .jsonAPI)
        }
    }
}
