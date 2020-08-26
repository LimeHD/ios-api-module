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
        path: String = "",
        acceptHeader: String = "",
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
    struct Banner { }
    struct Channels { }
}

extension EndPoint.Factory {
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
    
    static func archiveStream(for streamId: Int, start: Int, duration: Int) -> EndPoint {
        let urlParameters = [
            "id" : streamId.string,
            "start_at" : start.string,
            "duration" : duration.string
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/streams/\(streamId)/archive_redirect",
            parameters: parameters
        )
    }
    
    /// Создание `EndPoint` для запроса `deep_clicks`
    /// - Parameters:
    ///   - query: cтрока запроса
    ///   - path: путь запроса
    /// - Returns: `EndPoint` с параметрами для сетевого запроса `deep_clicks`
    ///
    /// В параметры запроса также входят `app_id` и `device_id`.
    /// `app_id` - задается при конфигурировании клиента `LimeAPIClient`.
    /// Параметр `device_id` - `LimeAPIClient` получает от устройства самостоятельно
    static func deepClicks(query: String, path: String) -> EndPoint {
        let bodyParameters = [
            "app_id" : EndPoint.appId,
            "query" : query,
            "path" : path,
            "device_id" : Device.id
        ]
        let parameters = EndPoint.Parameters(body: bodyParameters)
        return EndPoint(
            path: "v1/deep_clicks",
            acceptHeader: HTTP.Header.Accept.json,
            httpMethod: HTTP.Method.post,
            parameters: parameters
        )
    }
    
    /// Создание `EndPoint` для запроса информации о реферальной программе пользователя
    /// - Parameters:
    ///   - xToken: токен пользователя
    ///   - remoteIP: удаленный IP-адрес для тестирования
    /// - Returns: `EndPoint` с параметрами для запроса информации о реферальной программе пользователя
    ///
    /// В параметры запроса также входит `app_id`,
    /// который задается при конфигурировании клиента `LimeAPIClient`.
    static func referral(xToken: String, remoteIP: String) -> EndPoint {
        let urlParameters = [
            "X-Token" : xToken,
            "remote_ip" : remoteIP,
            "app_id" : EndPoint.appId
        ]
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/users/referral",
            acceptHeader: HTTP.Header.Accept.json,
            parameters: parameters
        )
    }
}

// MARK: - Banner Factory

extension EndPoint.Banner {
    enum Request: String {
        case find
        case next
    }
    
    static func find() -> EndPoint {
        return EndPoint.Banner.request(.find)
    }
    
    static func next() -> EndPoint {
        return EndPoint.Banner.request(.next)
    }
    
    private static func request(_ request: EndPoint.Banner.Request) -> EndPoint {
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

extension EndPoint.Channels {
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
        EndPoint.Channels.path("v1/channels/test")
    }
    
    static func all() -> EndPoint {
        EndPoint.Channels.path("v1/channels")
    }
    
    static func byGroupId(_ defaultChannelGroupId: String, cacheKey: String, timeZone: String, timeZonePicker: String) -> EndPoint {
        var urlParameters = ["locale" : EndPoint.languageDesignator]
        if !cacheKey.isEmpty {
            urlParameters["cache_key"] = cacheKey
        }
        if !timeZone.isEmpty {
            urlParameters["time_zone"] = timeZone
            urlParameters["time_zone_picker"] = timeZonePicker
        }
        let parameters = EndPoint.Parameters(url: urlParameters)
        return EndPoint(
            path: "v1/channels/by_group/\(defaultChannelGroupId)",
            acceptHeader: HTTP.Header.Accept.jsonAPI,
            parameters: parameters
        )
    }
}
