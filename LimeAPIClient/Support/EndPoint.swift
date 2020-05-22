//
//  EndPoint.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum EndPoint {
    case sessions
    case testChannels
    case channels
    // start и end в формате RFC3339, пример: 2020-04-29T23:59:59+03:00
    // timeZone - https://en.wikipedia.org/wiki/List_of_time_zones_by_country, пример: UTC+03:00
    case broadcasts(channelId: Int, start: String, end: String, timeZone: String)
    // key - (опционально) используется для разнообразия запросов и обхода кэша
    case ping(key: String)
}

extension EndPoint {
    var path: String {
        switch self {
        case .sessions:
            return "v1/sessions"
        case .testChannels:
            return "v1/channels/test"
        case .channels:
            return "v1/channels"
        case .broadcasts:
            return "v1/broadcasts"
        case .ping:
            return "v1/ping"
        }
    }
    
    var urlParameters: [String: String] {
        switch self {
        case
        .sessions,
        .testChannels,
        .channels:
            return [:]
        case .broadcasts(let channelId, let start, let end, let timeZone):
            return [
                "channel_id": "\(channelId)",
                "start_at": start.encoding(with: .rfc3986Allowed),
                "finish_at": end.encoding(with: .rfc3986Allowed),
                "time_zone": timeZone.encoding(with: .rfc3986Allowed)
            ]
        case .ping(let key):
            if key.isEmpty { return [:] }
            return [
                "key": key.encoding(with: .urlHostAllowed)
            ]
        }
    }
    
    var bodyParameters: [String: String] {
        switch self {
        case .sessions:
            return ["app_id": LimeAPIClient.configuration?.appId ?? ""]
        case
        .testChannels,
        .channels,
        .broadcasts,
        .ping:
            return [:]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .sessions:
            return HTTP.Method.post
        case
        .testChannels,
        .channels,
        .broadcasts,
        .ping:
            return HTTP.Method.get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case
        .testChannels,
        .channels,
        .broadcasts:
            return HTTP.headers(language: .ru, accept: .jsonAPI)
        case
        .sessions,
        .ping:
            return HTTP.headers(language: .ru, accept: .json)
        }
    }
}
