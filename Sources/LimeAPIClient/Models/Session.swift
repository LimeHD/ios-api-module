//
//  Session.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 22.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Session: Decodable, Equatable {
    public let sessionId: String
    public let currentTime: String
    public let streamEndpoint: String
    public let archiveEndpoint: String
    public let defaultChannelGroupId: Int
    public let settings: Settings
    public let meta: Meta
    
    public struct Settings: Decodable, Equatable {
        public let isAdStart: Bool
        public let isAdFirstStart: Bool
        public let isAdOnlStart: Bool
        public let isAdArhStart: Bool
        public let isAdOnlOut: Bool
        public let isAdArhOut: Bool
        public let isAdOnlFullOut: Bool
        public let isAdArhFullOut: Bool
        public let isAdArhPauseOut: Bool
        public let adMinTimeout: Int
    }
    
    public struct Meta: Decodable, Equatable {
        public let policyId: Int
    }
}
