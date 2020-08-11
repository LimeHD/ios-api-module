//
//  LimeAPIClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

let module = NSStringFromClass(LimeAPIClient.self).components(separatedBy:".")[0]

public typealias StringResult = Result<String, Error>
public typealias StringCompletion = (StringResult) -> Void
public typealias DecodableCompletion<T: Decodable> = (Result<T, Error>) -> Void
public typealias ImageResult = Result<UIImage, Error>
public typealias ImageCompletion = (ImageResult) -> Void

public enum APIError: Error, LocalizedError, Equatable {
    case unknownChannelsGroupId
    case jsonAPIError(_ statusCode: String, error: JSONAPIError)
    case wrongStatusCode(_ statusCode: String, error: String)
    case incorrectImageData
    case emptyBroadcastStartAt
    case emptyBroadcastDuration
    
    public var errorDescription: String? {
        switch self {
        case .unknownChannelsGroupId:
            let key = "Отсутствует id группы каналов. Возможно необходимо сделать запрос новой сессии"
            return NSLocalizedString(key, comment: "Отсутствует id группы каналов")
        case let .jsonAPIError(statusCode, error: error):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode). Ошибка: \(error)"
            return NSLocalizedString(key, comment: statusCode)
        case let .wrongStatusCode(statusCode, error: error):
            let key = "Неуспешный ответ состояния HTTP: \(statusCode). Ошибка: \(error)"
            return NSLocalizedString(key, comment: statusCode)
        case .incorrectImageData:
            let key = "Полученный формат данных изображения не поддерживается системой"
            return NSLocalizedString(key, comment: "Неверный формат данных")
        case .emptyBroadcastStartAt:
            let key = "Отсутствует время начала передачи"
            return NSLocalizedString(key, comment: key)
        case .emptyBroadcastDuration:
            let key = "Отсутствует длительность передачи"
            return NSLocalizedString(key, comment: key)
        }
    }
}

/// Общий клиент для работы с Лайм API. 
public final class LimeAPIClient {
    static var isVerboseEnabled = false
    let baseUrl: String
    let session: URLSession
    let mainQueue: Dispatchable
    /// Значения конфигурации клиента
    public static var configuration: LACConfiguration?
    
    /// Включает журналирование результатов запрос в консоли XCode
    public static func verbose() {
        LimeAPIClient.isVerboseEnabled = true
    }
    
    /// Инициализация клиента для работы с Лайм API
    /// - Parameters:
    ///   - baseUrl: адрес  сервера  API
    ///   - session: используется значение по умолчанию `URLSession.shared`
    ///   - mainQueue: очередь для возвращения запроса, по умолчанию используется значение `DispatchQueue.main`
    
    ///
    /// Пример инициализации:
    /// ```
    /// // Задание параметров конфигурации
    /// // Язык ожидаемого контента, который указывается запросе
    /// let language = Locale.preferredLanguages.first ?? "ru-RU"
    /// // APPLICATION_ID можно получить с помощью LACApp.id -
    /// // (идентификатор пакета, который определяется ключом CFBundleIdentifier)
    /// let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
    /// LimeAPIClient.configuration = configuration
    ///
    /// // Непосредственно инициализация
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// ```
    public init(baseUrl: String, session: URLSession = URLSession.shared, mainQueue: Dispatchable = DispatchQueue.main) {
        self.baseUrl = baseUrl
        self.session = session
        self.mainQueue = mainQueue
        
        LACStream.baseUrl = baseUrl
    }
    
    /// Запрос новой сессии
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.session { (result) in
    ///    switch result {
    ///    case .success(let session):
    ///        print(session)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func session(completion: @escaping DecodableCompletion<Session>) {
        self.request(Session.self, endPoint: EndPoint.Factory.session()) { (result) in
            switch result {
            case .success(let session):
                LimeAPIClient.configuration?.sessionId = session.sessionId
                LimeAPIClient.configuration?.streamEndpoint = session.streamEndpoint
                LimeAPIClient.configuration?.archiveEndpoint = session.archiveEndpoint
                LimeAPIClient.configuration?.defaultChannelGroupId = session.defaultChannelGroupId.string
                completion(.success(session))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Channels
    
    /// Запрос полного списка доступных каналов
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.requestChannels { (result) in
    ///    switch result {
    ///    case .success(let channels):
    ///        print(channels)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func requestChannels(completion: @escaping DecodableCompletion<[Channel]>) {
        self.request(JSONAPIObject<[Channel], String>.self, endPoint: EndPoint.Channels.all()) { (result) in
            self.handleJSONAPIResult(result, completion)
        }
    }
    
    /// Запрос списка каналов, доступных для приложения
    /// - Parameter cacheKey: ключ для сброса кеша
    /// - Parameter timeZone: часовой пояс
    /// - Parameter timeZonePicker: выбор часового пояса при отсутствии потока в часовом поясе `timeZone`, действует только если указан `timeZone`
    /// - Parameter completion: обработка результатов запроса
    ///
    /// - Attention: Перед выполеннием запроса необходимо создать успешную новую сессию для получения параметра `defaultChannelGroupId`
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// let cacheKey = "test"
    /// let timeZone = TimeZone(secondsFromGMT: 3.hours)
    /// let timeZonePicker = LACTimeZonePicker.previous
    /// apiClient.requestChannelsByGroupId(cacheKey: cacheKey, timeZone: timeZone, timeZonePicker: timeZonePicker) { (result) in
    ///    switch result {
    ///    case .success(let channels):
    ///        print(channels)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func requestChannelsByGroupId(cacheKey: String = "", timeZone: TimeZone? = nil, timeZonePicker: LACTimeZonePicker = .previous, completion: @escaping DecodableCompletion<[Channel]>) {
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        guard !defaultChannelGroupId.isEmpty else {
            let error = APIError.unknownChannelsGroupId
            completion(.failure(error))
            guard LimeAPIClient.isVerboseEnabled else { return }
            print("\(module)\n\(#function)\n\(error.localizedDescription)")
            return
        }
        let endPoint = EndPoint.Channels.byGroupId(
            defaultChannelGroupId,
            cacheKey: cacheKey,
            timeZone: timeZone?.utcString ?? "",
            timeZonePicker: timeZonePicker.rawValue)
        self.request(JSONAPIObject<[Channel], String>.self, endPoint: endPoint) { (result) in
            self.handleJSONAPIResult(result, completion)
        }
    }
    
    /// Запрос списка передач
    /// - Parameter channelId: id канала, для которого делается запрос
    /// - Parameter dateInterval: временной интервал и часовой пояс для которого делается запрос
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса для канала с id 105:
    /// ```
    /// // Начальная дата ранее текущей даты на 8 дней
    /// let startDate = Date().addingTimeInterval(-8.days)
    /// // Часовой пояс +3 часа
    /// let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
    /// // Временной интервал продолжительностью 15 дней
    /// let dateInterval = LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.requestBroadcasts(channelId: 105, dateInterval: dateInterval) { (result) in
    ///    switch result {
    ///    case .success(let broadcasts):
    ///        print(broadcasts)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func requestBroadcasts(
        channelId: Int,
        dateInterval: LACDateInterval,
        completion: @escaping DecodableCompletion<[Broadcast]>
    ) {
        let timeZone = dateInterval.timeZone
        let start = RFC3339Date(date: dateInterval.start, timeZone: timeZone).string
        let end = RFC3339Date(date: dateInterval.end, timeZone: timeZone).string
        let endPoint = EndPoint.Factory.broadcasts(
            channelId: channelId,
            start: start,
            end: end,
            timeZone: timeZone.utcString)
        self.request(JSONAPIObject<[Broadcast], Broadcast.Meta>.self, endPoint: endPoint) { (result) in
            self.handleJSONAPIResult(result, completion)
        }
    }
    
    /// Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки
    /// - Parameter key: опциональный параметр. Используется для разнообразия запросов и обхода кэша
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.ping(key: KEY) { (result) in
    ///    switch result {
    ///    case .success(let ping):
    ///        print(ping)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func ping(key: String = "", completion: @escaping DecodableCompletion<Ping>) {
        self.request(Ping.self, endPoint: EndPoint.Factory.ping(key: key)) { (result) in
            completion(result)
        }
    }
    
    /// Запрос для deep clicks
    /// - Parameters:
    ///   - query: cтрока запроса
    ///   - path: путь запроса
    ///   - completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// // QUERY - cтрока запроса
    /// // PATH - путь запроса
    /// apiClient.deepClicks(query: QUERY, path: PATH) { (result) in
    ///    switch result {
    ///    case .success(let message):
    ///        print(message)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public func deepClicks(query: String, path: String, completion: @escaping StringCompletion) {
        let endPoint = EndPoint.Factory.deepClicks(query: query, path: path)
        self.request(endPoint) { (result) in
            completion(result)
        }
    }
}

// MARK: - Banners

public extension LimeAPIClient {
    /// Запрос подходящего баннера на проверку без ротации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.findBanner { (result) in
    ///    switch result {
    ///    case .success(let bannerAndDevice):
    ///        print(bannerAndDevice)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    func findBanner(completion: @escaping DecodableCompletion<BannerAndDevice>) {
        self.request(BannerAndDevice.self, endPoint: EndPoint.Banner.find()) { (result) in
            completion(result)
        }
    }
    
    /// Запрос баннера, рекомендованного данному устройству и приложению
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.nextBanner { (result) in
    ///    switch result {
    ///    case .success(let banner):
    ///        print(banner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    func nextBanner(completion: @escaping DecodableCompletion<BannerAndDevice.Banner>) {
        self.request(BannerAndDevice.Banner.self, endPoint: EndPoint.Banner.next()) { (result) in
            completion(result)
        }
    }
    
    /// Запрос на снятие (удаление) пометки "нежелательный" с баннера
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.deleteBanFromBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banBanner):
    ///        print(banBanner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    func deleteBanFromBanner(bannerId: Int, completion: @escaping DecodableCompletion<BanBanner>) {
        let endPoint = EndPoint.Banner.deleteBan(bannerId)
        self.handleBanBannerRequest(endPoint: endPoint, completion: completion)
    }
    
    /// Запрос на установку для баннер метки "нежелательный" и больше его не показывать
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.banBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banBanner):
    ///        print(banBanner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    func banBanner(bannerId: Int, completion: @escaping DecodableCompletion<BanBanner>) {
        let endPoint = EndPoint.Banner.ban(bannerId)
        self.handleBanBannerRequest(endPoint: endPoint, completion: completion)
    }
    
    /// Запрос на получение баннера (информации о нём)
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // BASE_URL - адрес  сервера  API
    /// let apiClient = LimeAPIClient(baseUrl: BASE_URL)
    /// apiClient.getBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banner):
    ///        print(banner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    func getBanner(bannerId: Int, completion: @escaping DecodableCompletion<BannerAndDevice.Banner>) {
        self.request(BannerAndDevice.Banner.self, endPoint: EndPoint.Banner.info(bannerId)) { (result) in
            completion(result)
        }
    }
    
    func getImage(with path: String, completion: @escaping ImageCompletion) {
        self.requestImage(with: path) { (result) in
            switch result {
            case .success(let image):
                self.mainQueue.async { completion(.success(image)) }
            case .failure(let error):
                self.mainQueue.async { completion(.failure(error)) }
            }
        }
    }
    
    func getOnlinePlaylist(for streamId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let request: URLRequest
        do {
            let path = try LACStream.Online.endpoint(for: streamId)
            request = try URLRequest(path: path)
        } catch {
            completion(.failure(error))
            return
        }
        
        self.requestStringData(with: request) { (result) in
            completion(result)
        }
    }
    
    func getArchivePlaylist(for streamId: Int, startAt: Int, duration: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endPoint = EndPoint.Factory.archiveStream(for: streamId, start: startAt, duration: duration)
        let request: URLRequest
        do {
            request = try URLRequest(baseUrl: self.baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        self.requestStringData(with: request) { (result) in
            completion(result)
        }
    }
    
    func getArchivePlaylist(for streamId: Int, broadcast: Broadcast, completion: @escaping (Result<String, Error>) -> Void) {
        guard let startAt = broadcast.startAtUnix else {
            let error = APIError.emptyBroadcastStartAt
            completion(.failure(error))
            return
        }
        guard let duration = broadcast.duration else {
            let error = APIError.emptyBroadcastDuration
            completion(.failure(error))
            return
        }
        self.getArchivePlaylist(for: streamId, startAt: startAt, duration: duration) { (result) in
            completion(result)
        }
    }
}

//MARK: - Private Methods

typealias JSONAPIResult<T: Decodable, U: Decodable> = Result<JSONAPIObject<[T], U>, Error>

extension LimeAPIClient {
    //MARK: - Decodable Requests Methods
    
    private func request<T: Decodable>(_ type: T.Type, endPoint: EndPoint, completion: @escaping DecodableCompletion<T>) {
        let request: URLRequest
        do {
            request = try URLRequest(baseUrl: self.baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        self.dataTask(with: request, T.self) { (result) in
            if case .failure(let error) = result {
                LimeAPIClient.log(request, message: error.localizedDescription)
            }
            self.mainQueue.async { completion(result) }
        }
    }
    
    private func dataTask<T: Decodable>(with request: URLRequest, _ type: T.Type, completion: @escaping DecodableCompletion<T>) {
        HTTPClient(self.session).dataTask(with: request) { (result) in
            switch result {
            case .success(let result):
                LimeAPIClient.log(request, message: result.response.localizedStatusCode)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try T(decoding: result.data, decoder: decoder)
                    completion(.success(result))
                } catch {
                    var message = error.localizedDescription + "\n"
                    message += "Ошибка при парсинге JSON-файла:\n"
                    message += "-----------------------------------\n"
                    message += String(decoding: result.data, as: UTF8.self) + "\n"
                    message += "-----------------------------------\n"
                    LimeAPIClient.log(request, message: message)
                    completion(.failure(error))
                }
            case .failure(let error):
                self.handleErorr(error, completion)
            }
        }
    }
    
    private func handleJSONAPIResult<T: Decodable, U: Decodable>(_ result: JSONAPIResult<T, U>, _ completion: @escaping DecodableCompletion<[T]>) {
        switch result {
        case .success(let result):
            completion(.success(result.data))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func handleBanBannerRequest(endPoint: EndPoint, completion: @escaping DecodableCompletion<BanBanner>) {
        self.request(BanBanner.self, endPoint: endPoint) { (result) in
            completion(result)
        }
    }
    
    private func handleErorr<T: Decodable>(_ error: Error, _ completion: @escaping DecodableCompletion<T>) {
        if let error = error as? HTTPClient.Error,
            case let .wrongStatusCode(data, response) = error {
            self.decodeError(data, response, completion)
        } else {
            completion(.failure(error))
        }
    }
    
    private func decodeError<T>(_ data: Data, _ response: HTTPURLResponse, _ completion: @escaping DecodableCompletion<T>) {
        do {
            let jsonAPIError = try JSONAPIError(decoding: data)
            let error = APIError.jsonAPIError(response.localizedStatusCode, error: jsonAPIError)
            completion(.failure(error))
        } catch {
            let message = String(decoding: data, as: UTF8.self)
            let error = APIError.wrongStatusCode(response.localizedStatusCode, error: message)
            completion(.failure(error))
        }
    }
    
    //MARK: - String Request Methods
    
    private func request(_ endPoint: EndPoint, completion: @escaping StringCompletion) {
        let request: URLRequest
        do {
            request = try URLRequest(baseUrl: self.baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        self.dataTask(with: request) { (result) in
            if case .failure(let error) = result {
                LimeAPIClient.log(request, message: error.localizedDescription)
            }
            self.mainQueue.async { completion(result) }
        }
    }
    
    private func dataTask(with request: URLRequest, completion: @escaping StringCompletion) {
        HTTPClient(self.session).dataTask(with: request) { (result) in
            switch result {
            case .success(let result):
                let message = String(decoding: result.data, as: UTF8.self)
                completion(.success(message))
            case .failure(let error):
                self.handleErorr(error, completion)
            }
        }
    }
    
    //MARK: - Image Request Methods
    
    private func requestImage(with path: String, completion: @escaping ImageCompletion) {
        let request: URLRequest
        do {
            request = try URLRequest(path: path)
        } catch {
            completion(.failure(error))
            return
        }
        
        HTTPClient(self.session).dataTask(with: request) { (result) in
            switch result {
            case .success(let result):
                if let image = UIImage(data: result.data) {
                    completion(.success(image))
                } else {
                    let error = APIError.incorrectImageData
                    completion(.failure(error))
                }
            case .failure(let error):
                LimeAPIClient.log(request, message: error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    private func requestStringData(with request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        HTTPClient(self.session).dataTask(with: request) { (result) in
            switch result {
            case .success(let result):
                let playlist = String(decoding: result.data, as: UTF8.self)
                self.mainQueue.async { completion(.success(playlist)) }
            case .failure(let error):
                LimeAPIClient.log(request, message: error.localizedDescription)
                self.mainQueue.async { completion(.failure(error)) }
            }
        }
    }
    
    private static func log(_ request: URLRequest, message: String) {
        guard LimeAPIClient.isVerboseEnabled else { return }
        let url = request.url?.absoluteString ?? "(пустое значение ulr)"
        print("\(module)\n\(url)\n\(message)")
    }
}
