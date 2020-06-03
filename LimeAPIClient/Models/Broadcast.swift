//
//  Broadcast.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 20.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Broadcast: Decodable, Equatable {
    public let id: String
    public let type: String
    public let attributes: Attributes
    
    public struct Attributes: Decodable, Equatable {
        public let title: String
        public let detail: String
        public let rating: Int?
        public let startAt: String
        public let finishAt: String
    }
    
    struct Meta: Decodable, Equatable {
        let timeZone: String
        let startAt: String
        let finishAt: String
    }
}
