//
//  JSONAPIError.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 19.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct JSONAPIError: Decodable, Equatable {
    public let errors: [Error]
    public let meta: Meta
    
    public struct Error: Decodable, Equatable {
        public let id: Int?
        public let status: String
        public let code: String
        public let title: String
        public let detail: String?
    }
    
    public struct Meta: Decodable, Equatable {
        public let requestId: String
    }
}
