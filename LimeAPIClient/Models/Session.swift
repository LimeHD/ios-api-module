//
//  Session.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 22.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Session: Decodable {
    public let sessionId: String
    public let currentTime: String
    public let streamEndpoint: String
    public let defaultChannelGroupId: Int
}
