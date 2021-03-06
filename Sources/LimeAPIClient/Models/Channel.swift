//
//  Channel.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Channel: Decodable, Equatable {
    public let id: String
    public let type: String
    public let attributes: Attributes
    
    public struct Attributes: Decodable, Equatable {
        public let name: String?
        public let imageUrl: String?
        public let description: String?
        public let streams: [Stream]
    }
    
    public struct Stream: Decodable, Equatable {
        public let id: Int
        public let timeZone: String
        public let archiveHours: Int
        public let contentType: String?
    }
    
    
}
