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
    case wrongStatusCode(_ statusCode: String, error: String)
    case incorrectImageData
    
    public var errorDescription: String? {
        switch self {
        case .sessionError:
            let key = "Отсутствует общая ссылка на поток. Возможно необходимо сделать запрос новой сессии"
            return NSLocalizedString(key, comment: "Отсутствует общая ссылка на поток")
        case .invalidUrl(let url):
            let key = "Недопустимое значение ссылки на поток: \(url)"
            return NSLocalizedString(key, comment: "Недопустимое значение ссылки на поток")
        case let .wrongStatusCode(statusCode, error: error):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode). Ошибка: \(error)"
            return NSLocalizedString(key, comment: statusCode)
        case .incorrectImageData:
            let key = "Полученный формат данных изображения не поддерживается системой"
            return NSLocalizedString(key, comment: "Неверный формат данных")
        }
    }
}

public struct LACStream {
    private static var streamEndpoint: String {
        LimeAPIClient.configuration?.streamEndpoint.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    static func streamEndpoint(_ streamId: Int) throws -> String {
        let path = LACStream.streamEndpoint
        if path.isEmpty {
            throw LACStreamError.sessionError
        }
        return path.replacingOccurrences(of: "${stream_id}", with: streamId.string)
    }
    
    public static func online(streamId: Int) throws -> AVURLAsset {
        let streamPath = try LACStream.streamEndpoint(streamId)
        guard let url = URL(string: streamPath) else {
            throw LACStreamError.invalidUrl(streamPath)
        }
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": HTTP.headers])
        return asset
    }
}
