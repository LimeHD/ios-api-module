//
//  APIRequest.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum APIRequest: String {
    case sessions
    case ping
    case channels
    case channelsByGroupId = "channels by group id"
    case broadcasts
    
    struct Parameter {
        let name: String
        let detail: String
    }
    
    struct Result {
        let title: String
        let detail: String
    }
}
