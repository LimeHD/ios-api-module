//
//  HTTP.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

struct HTTP {
    struct Header {
        enum Accept: String {
            case jsonAPI = "application/vnd.api+json"
            case json = "application/json"
        }
        enum ContentType: String {
            case none = ""
            case formUrlEncoded = "application/x-www-form-urlencoded"
        }
    }
    
    struct Method { }
    
    static func headers(
        accept: Header.Accept,
        contentType: Header.ContentType = .none) -> [String: String]
    {
        var headers = [
            "Accept":           accept.rawValue,
            "Accept-Language":  LimeAPIClient.configuration?.language ?? "",
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

//MARK: - HTTP Methods

typealias HTTPMethod = String

extension HTTP.Method {
    static var get      = "GET"
    static var post     = "POST"
    static var put      = "PUT"
    static var patch    = "PATCH"
    static var delete   = "DELETE"
}
