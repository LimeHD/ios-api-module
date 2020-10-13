//
//  HTTP.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct HTTP {
    struct Header {
        struct Accept {
            static var jsonAPI = "application/vnd.api+json"
            static var json = "application/json"
        }
        struct ContentType {
            static var urlEncodedForm = "application/x-www-form-urlencoded"
        }
    }
    
    struct Method { }
    
    public static var headers: [String: String] {
        return [
            "Accept-Language":  LimeAPIClient.configuration?.language ?? "",
            "X-Platform":       "ios",
            "X-Device-Name":    Device.name,
            "X-Device-Id":      Device.id,
            "X-App-Id":         LimeAPIClient.identification?.appId ?? "",
            "X-App-Version":    LACApp.version,
            "X-Access-Key":     LimeAPIClient.identification?.apiKey ?? "",
            "X-Session-Id":     LimeAPIClient.identification?.sessionId ?? "",
            "X-Token":          LimeAPIClient.xToken
        ]
    }
}

//MARK: - HTTP Methods

extension HTTP.Method {
    static var get      = "GET"
    static var post     = "POST"
    static var put      = "PUT"
    static var patch    = "PATCH"
    static var delete   = "DELETE"
}
