//
//  LACStream.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 17.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import AVFoundation

public struct LACStream {
    public enum Error: Swift.Error, LocalizedError, Equatable {
        case sessionError
        case invalidUrl(_ url: String)
        case emptyBaseUrl
        case emptyArchiveUrl
    }
    
    static var baseUrl = ""
    private static func urlAsset(_ url: URL) -> AVURLAsset {
        AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": HTTP.headers])
    }
    
    public struct Online {
        private init() { }
    }
    public struct Archive {
        private init() { }
    }
}

public extension LACStream.Error {
    var errorDescription: String? {
        switch self {
        case .sessionError:
            let key = "Отсутствует общая ссылка на поток. Возможно необходимо сделать запрос новой сессии"
            return NSLocalizedString(key, comment: "Отсутствует общая ссылка на поток")
        case .invalidUrl(let url):
            let key = "Недопустимое значение ссылки на поток: \(url)"
            return NSLocalizedString(key, comment: "Недопустимое значение ссылки на поток")
        case .emptyBaseUrl:
            let key = "Отсутсвует ссылка на сервер API (baseUrl)"
            return NSLocalizedString(key, comment: "Отсутсвует ссылка на сервер API")
        case .emptyArchiveUrl:
            let key = "Сбой при создании ссылки на поток архива"
            return NSLocalizedString(key, comment: key)
        }
    }
}

public extension LACStream.Online {
    private static var endpoint: String {
        LimeAPIClient.configuration?.streamEndpoint.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    static internal func endpoint(for streamId: Int) throws -> String {
        let path = LACStream.Online.endpoint
        if path.isEmpty {
            throw LACStream.Error.sessionError
        }
        return path.replacingOccurrences(of: "${stream_id}", with: streamId.string)
    }
    
    /// Получение ссылки для [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer) на онлайн поток
    /// - Parameter streamId: id онлайн потока
    /// - Throws: Возращает ошибку в случае неверной ссылки на поток (не была запрошена новая сессия или получен неверный формат ссылки)
    /// - Returns: Возвращает ссылку на онлайн поток в формате [AVURLAsset](https://developer.apple.com/documentation/avfoundation/avurlasset)
    ///
    /// Перед использованием необходимо сделать запрос новой сессии для получения ссылки на онлайн поток.
    /// Сессия запрашивается один раз за все время запуска приложения.
    ///
    /// Пример использования:
    /// ```
    /// import LimeAPIClient
    /// import AVKit
    ///
    /// // Запрос новой сессии для получения ссылки на онлайн-поток
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.session { (result) in
    ///    switch result {
    ///    case .success(let session):
    ///        print(session)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    ///
    /// let streamId = 44
    /// let asset: AVURLAsset
    /// do {
    ///     asset = try LACStream.Online.urlAsset(for: streamId)
    /// } catch {
    ///     print(error)
    ///     return
    /// }
    ///
    /// let playerItem = AVPlayerItem(asset: asset)
    /// let player = AVPlayer(playerItem: playerItem)
    /// let playerViewController = AVPlayerViewController()
    /// playerViewController.player = player
    /// self.present(playerViewController, animated: true) {
    ///     playerViewController.player!.play()
    /// }
    /// ```
    static func urlAsset(for streamId: Int) throws -> AVURLAsset {
        let streamPath = try LACStream.Online.endpoint(for: streamId)
        guard let url = URL(string: streamPath) else {
            throw LACStream.Error.invalidUrl(streamPath)
        }
        return LACStream.urlAsset(url)
    }
}

public extension LACStream.Archive {
    static func urlAsset(for streamId: Int, start: Int, duration: Int) throws -> AVURLAsset {
        if LACStream.baseUrl.isEmpty {
            throw LACStream.Error.emptyBaseUrl
        }
        let endPoint = EndPoint.Factory.archiveStream(for: streamId, start: start, duration: duration)
        guard let url = try URLRequest(baseUrl: LACStream.baseUrl, endPoint: endPoint).url else {
            throw LACStream.Error.emptyArchiveUrl
        }
        return LACStream.urlAsset(url)
    }
}
