//
//  EndPoint.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum EndPoint {
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
        .testChannels,
        .channels:
            return [:]
        case .broadcasts(let channelId, let start, let end, let timeZone):
            return [
                "channel_id": "\(channelId)",
                "start_at": start.encoding(with: .httpHostAllowed),
                "finish_at": end.encoding(with: .httpHostAllowed),
                "time_zone": timeZone.encoding(with: .httpHostAllowed)
            ]
        case .ping(let key):
            if key.isEmpty { return [:] }
            return [
                "key": key.encoding(with: .urlHostAllowed)
            ]
        }
    }
    
    var httpMethod: String {
        switch self {
        case
        .testChannels,
        .channels,
        .broadcasts,
        .ping:
            return HTTP.Method.get
        }
    }
    
    func headers(with appId: String) -> [String: String] {
        let http = HTTP(appId: appId)
        switch self {
        case
        .testChannels,
        .channels,
        .broadcasts:
            return http.headers(language: .ru, accept: .jsonAPI)
        case .ping:
            return http.headers(language: .ru, accept: .json)
        }
    }
}
