//
//  EndPoint.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct EndPoint {
    let path: String
    let acceptHeader: String
    let httpMethod: String
    let parameters: EndPoint.Parameters
    
    init(
        path: String,
        acceptHeader: String,
        httpMethod: String = HTTP.Method.get,
        parameters: EndPoint.Parameters = EndPoint.Parameters()
    ) {
        self.path = path
        self.acceptHeader = acceptHeader
        self.httpMethod = httpMethod
        self.parameters = parameters
    }
    
    struct Parameters {
        let url: [String : String]
        let body: [String : String]
        
        init(
            url: [String : String] = [:],
            body: [String : String] = [:]
        ) {
            self.url = url
            self.body = body
        }
    }
    
    struct Factory { }
}

extension EndPoint.Factory {
    static func session() -> EndPoint {
        let parameters = EndPoint.Parameters(
            body: ["app_id": LimeAPIClient.configuration?.appId ?? ""]
        )
        return EndPoint(
            path: "v1/sessions",
            acceptHeader: HTTP.Header.Accept.json,
            httpMethod: HTTP.Method.post,
            parameters: parameters
        )
    }
    
    static func testChannels() -> EndPoint {
        return EndPoint(
            path: "v1/channels/test",
            acceptHeader: HTTP.Header.Accept.jsonAPI
        )
    }
    
    static func findBanner() -> EndPoint {
        let urlParameters = [
            "device_id": Device.id,
            "app_id": LimeAPIClient.configuration?.appId ?? "",
            "platform": "ios"
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/banners/recommended/find",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
    
    static func channels() -> EndPoint {
        return EndPoint(
            path: "v1/channels",
            acceptHeader: HTTP.Header.Accept.jsonAPI
        )
    }
    
    static func channelsByGroupId(_ defaultChannelGroupId: String) -> EndPoint {
        return EndPoint(
            path: "v1/channels/by_group/\(defaultChannelGroupId)",
            acceptHeader: HTTP.Header.Accept.jsonAPI
        )
    }
    
    // start и end в формате RFC3339, пример: 2020-04-29T23:59:59+03:00
    // timeZone - https://en.wikipedia.org/wiki/List_of_time_zones_by_country, пример: UTC+03:00
    static func broadcasts(channelId: Int, start: String, end: String, timeZone: String) -> EndPoint {
        let urlParameters = [
            "channel_id": "\(channelId)",
            "start_at": start,
            "finish_at": end,
            "time_zone": timeZone
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/broadcasts",
            acceptHeader: HTTP.Header.Accept.jsonAPI,
            parameters: parameters
        )
    }
    
    // key - (опционально) используется для разнообразия запросов и обхода кэша
    static func ping(key: String) -> EndPoint {
        let urlParameters: [String : String]
        if key.isEmpty {
            urlParameters = [:]
        } else {
            urlParameters = ["key": key.encoding(with: .rfc3986Allowed)]
        }
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/ping",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
}
