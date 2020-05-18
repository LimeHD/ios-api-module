//
//  HTTP.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct HTTP {
    struct Header {
        enum Accept: String {
            case jsonAPI = "application/vnd.api+json"
        }
        enum Language: String {
            case ru = "ru-RU"
        }
    }
    
    struct Method {
        static var get      = "GET"
        static var post     = "POST"
        static var put      = "PUT"
        static var patch    = "PATCH"
        static var delete   = "DELETE"
    }
    
    static func headers(language: Header.Language, accept: Header.Accept) -> [String: String] {
        [
            "Accept":           accept.rawValue,
            "Accept-Language":  language.rawValue,
            "X-Platform":       "ios",
            "X-Device-Name":    Device.name,
            "X-Device-Id":      Device.id,
            "X-App-Id":         App.id,
            "X-App-Version":    App.version
        ]
    }
}
