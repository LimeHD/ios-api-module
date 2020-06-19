//
//  LACStream.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 17.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import AVFoundation

public enum LACStreamError: Error, LocalizedError, Equatable {
    case sessionError
    case invalidUrl(_ url: String)
    
    public var errorDescription: String? {
        switch self {
        case .sessionError:
            let key = "Отсутствует общая ссылка на поток. Возможно необходимо сделать запрос новой сессии"
            return NSLocalizedString(key, comment: "Отсутствует общая ссылка на поток")
        case .invalidUrl(let url):
            let key = "Недопустимое значение ссылки на поток: \(url)"
            return NSLocalizedString(key, comment: "Недопустимое значение ссылки на поток")
        }
    }
}

public struct LACStream {
    public struct Online {
        private init() { }
    }
    public struct Archive {
        private init() { }
    }
}

public extension LACStream.Online {
    private static var endpoint: String {
        LimeAPIClient.configuration?.streamEndpoint.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    static func endpoint(for streamId: Int) throws -> String {
        let path = LACStream.Online.endpoint
        if path.isEmpty {
            throw LACStreamError.sessionError
        }
        return path.replacingOccurrences(of: "${stream_id}", with: streamId.string)
    }
    
    static func urlAsset(for streamId: Int) throws -> AVURLAsset {
        let streamPath = try LACStream.Online.endpoint(for: streamId)
        guard let url = URL(string: streamPath) else {
            throw LACStreamError.invalidUrl(streamPath)
        }
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": HTTP.headers])
        return asset
    }
}

public extension LACStream.Archive {
    private static var endpoint: String {
        LimeAPIClient.configuration?.streamEndpoint.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    static func endpoint(baseUrl: String, for streamId: Int) throws -> String {
        let path = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if path.isEmpty {
            throw LACStreamError.sessionError
        }
        return path.replacingOccurrences(of: "${stream_id}", with: streamId.string)
    }
    
    static func urlAsset(for streamId: Int) throws -> AVURLAsset {
        let streamPath = try LACStream.Online.endpoint(for: streamId)
        guard let url = URL(string: streamPath) else {
            throw LACStreamError.invalidUrl(streamPath)
        }
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": HTTP.headers])
        return asset
    }
}
