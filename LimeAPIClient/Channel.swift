//
//  Channel.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Channel: Decodable {
    struct Stream: Decodable {
        let id: Int
        let timeZone: String
        let contentType: String
    }
    
    let name: String?
    let imageUrl: String?
    let description: String?
    let streams: [Stream]
}
