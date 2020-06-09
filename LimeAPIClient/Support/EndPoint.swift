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
    static var appId: String {
        LimeAPIClient.configuration?.appId ?? ""
    }
    static var languageDesignator: String {
        LimeAPIClient.configuration?.languageDesignator ?? ""
    }
    
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
    
    struct Parameters: Equatable {
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
    struct Banner {
        private init() { }
    }
    
    struct Channels {
        private init() { }
    }
    
    static func session() -> EndPoint {
        let parameters = EndPoint.Parameters(
            body: ["app_id" : EndPoint.appId]
        )
        return EndPoint(
            path: "v1/sessions",
            acceptHeader: HTTP.Header.Accept.json,
            httpMethod: HTTP.Method.post,
            parameters: parameters
        )
    }
    
    // start и end в формате RFC3339, пример: 2020-04-29T23:59:59+03:00
    // timeZone - https://en.wikipedia.org/wiki/List_of_time_zones_by_country, пример: UTC+03:00
    static func broadcasts(channelId: Int, start: String, end: String, timeZone: String) -> EndPoint {
        let urlParameters = [
            "channel_id" : channelId.string,
            "start_at" : start,
            "finish_at" : end,
            "time_zone" : timeZone,
            "locale" : EndPoint.languageDesignator
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
            urlParameters = ["key" : key.encoding(with: .rfc3986Allowed)]
        }
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/ping",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
}

// MARK: - Banner Factory

extension EndPoint.Factory.Banner {
    enum Request: String {
        case find
        case next
    }
    
    static func find() -> EndPoint {
        return EndPoint.Factory.Banner.request(.find)
    }
    
    static func next() -> EndPoint {
        return EndPoint.Factory.Banner.request(.next)
    }
    
    private static func request(_ request: EndPoint.Factory.Banner.Request) -> EndPoint {
        let urlParameters = [
            "device_id" : Device.id,
            "app_id" : EndPoint.appId,
            "platform" : "ios"
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/banners/recommended/\(request.rawValue)",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
    
    static func deleteBan(_ bannerId: Int) -> EndPoint {
        let parameters = EndPoint.Parameters(url: ["device_id" : Device.id])
        return EndPoint(
            path: "v1/banners/\(bannerId)/ban",
            acceptHeader: HTTP.Header.Accept.json,
            httpMethod: HTTP.Method.delete,
            parameters: parameters
        )
    }
    
    static func ban(_ bannerId: Int) -> EndPoint {
        let parameters = EndPoint.Parameters(body: ["device_id" : Device.id])
        return EndPoint(
            path: "v1/banners/\(bannerId)/ban",
            acceptHeader: HTTP.Header.Accept.json,
            httpMethod: HTTP.Method.post,
            parameters: parameters
        )
    }
    
    static func info(_ bannerId: Int) -> EndPoint {
        let parameters = EndPoint.Parameters(url: ["device_id" : Device.id])
        return EndPoint(
            path: "v1/banners/\(bannerId)",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
}


// MARK: - Сhannels Factory

extension EndPoint.Factory.Channels {
    static func path(_ path: String) -> EndPoint {
        let urlParameters = [
            "locale" : EndPoint.languageDesignator
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        
        return EndPoint(
            path: path,
            acceptHeader: HTTP.Header.Accept.jsonAPI,
            parameters: parameters
        )
    }
    
    static func test() -> EndPoint {
        EndPoint.Factory.Channels.path("v1/channels/test")
    }
    
    static func all() -> EndPoint {
        EndPoint.Factory.Channels.path("v1/channels")
    }
    
    static func byGroupId(_ defaultChannelGroupId: String) -> EndPoint {
        EndPoint.Factory.Channels.path("v1/channels/by_group/\(defaultChannelGroupId)")
    }
}
