//
//  HTTP.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias HTTPAcceptHeader = String

struct HTTP {
    struct Header {
        struct Accept {
            static var jsonAPI = "application/vnd.api+json"
            static var json = "application/json"
        }
        struct ContentType {
            static var formUrlEncoded = "application/x-www-form-urlencoded"
        }
    }
    
    struct Method { }
    
    static func headers(accept: HTTPAcceptHeader) -> HTTPHeaders
    {
        return [
            "Accept":           accept,
            "Accept-Language":  LimeAPIClient.configuration?.language ?? "",
            "X-Platform":       "ios",
            "X-Device-Name":    Device.name,
            "X-Device-Id":      Device.id,
            "X-App-Id":         LimeAPIClient.configuration?.appId ?? "",
            "X-App-Version":    LACApp.version,
            "X-Access-Key":     LimeAPIClient.configuration?.apiKey ?? ""
        ]
    }
}

//MARK: - HTTP Methods

typealias HTTPMethod = String

extension HTTP.Method {
    static var get      = "GET"
    static var post     = "POST"
    static var put      = "PUT"
    static var patch    = "PATCH"
    static var delete   = "DELETE"
}
