//
//  HTTP.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct HTTP {
    let appId: String
    
    struct Header {
        enum Accept: String {
            case jsonAPI = "application/vnd.api+json"
            case json = "application/json"
        }
        enum ContentType: String {
            case none = ""
            case formUrlencoded = "application/x-www-form-urlencoded"
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
    
    static func headers(language: Header.Language, accept: Header.Accept, contentType: Header.ContentType = .none) -> [String: String] {
        var headers = [
            "Accept":           accept.rawValue,
            "Accept-Language":  language.rawValue,
            "X-Platform":       "ios",
            "X-Device-Name":    Device.name,
            "X-Device-Id":      Device.id,
            "X-App-Id":         LimeAPIClient.configuration?.appId ?? "",
            "X-App-Version":    LACApp.version,
            "X-Access-Key":     LimeAPIClient.configuration?.apiKey ?? ""
        ]
        
        if contentType != .none {
            headers["Content-Type"] = contentType.rawValue
        }
        
        return headers
    }
}
