//
//  Ping.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 19.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Ping: Decodable, Equatable {
    public let result: String
    public let time: String
    public let version: String
    public let hostname: String
}
