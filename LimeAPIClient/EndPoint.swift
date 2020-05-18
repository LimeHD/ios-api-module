//
//  EndPoint.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 14.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public enum EndPoint {
    case testChannels
    case channels
    // startAt and finishAt - RFC3339, format example: 2020-04-29T23:59:59+03:00
    // timeZone - https://en.wikipedia.org/wiki/List_of_time_zones_by_country, format example: UTC+03:00
    case broadcasts(channelId: Int, start: String, end: String, timeZone: String)
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
        }
    }
    
    var httpMethod: String {
        switch self {
        case
        .testChannels,
        .channels,
        .broadcasts:
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
        }
    }
}
