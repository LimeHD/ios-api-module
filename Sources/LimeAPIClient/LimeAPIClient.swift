//
//  LimeAPIClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import HTTPURLRequest

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
    case emptyConfiguration
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
        case .emptyConfiguration:
            let key = "Отсутствуют параметры конфигурации"
            return NSLocalizedString(key, comment: key)
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
public struct LimeAPIClient {
    static var isVerboseEnabled = false
    /// Значения конфигурации клиента
    static var configuration: LACConfiguration?
    /// Значения идентификаторов клиента
    static var identification: LACIdentification?
    
    /// Токен пользователя
    public static var xToken = ""
    
    /// Включает журналирование результатов запрос в консоли XCode
    public static func verbose() {
        LimeAPIClient.isVerboseEnabled = true
    }
    
    /// Устанавливает значения идентификаторов клиента
    /// - Parameter identification: идентификаторы клиента
    public static func setIdentification(_ identification: LACIdentification?) {
        LimeAPIClient.identification = identification
    }
    /// Устанавливает значения конфигурацию клиента
    /// - Parameter configuration: конфигурация клиента
    public static func setConfiguration(_ configuration: LACConfiguration?) {
        LimeAPIClient.configuration = configuration
        LACStream.baseUrl = configuration?.baseUrl ?? ""
    }
    
    /// Запрос новой сессии
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.session { (result) in
    ///    switch result {
    ///    case .success(let session):
    ///        print(session)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func session(completion: @escaping DecodableCompletion<Session>) {
        LimeAPIClient.request(Session.self, endPoint: EndPoint.Factory.session()) { (result) in
            switch result {
            case let .success(session):
                LimeAPIClient.identification?.sessionId = session.sessionId
                LimeAPIClient.configuration?.streamEndpoint = session.streamEndpoint
                LimeAPIClient.configuration?.archiveEndpoint = session.archiveEndpoint
                LimeAPIClient.configuration?.defaultChannelGroupId = session.defaultChannelGroupId.string
                completion(.success(session))
            case let .failure(error):
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
    /// LimeAPIClient.requestChannels { (result) in
    ///    switch result {
    ///    case .success(let channels):
    ///        print(channels)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func requestChannels(completion: @escaping DecodableCompletion<[Channel]>) {
        let endPoint = EndPoint.Channels.all()
        LimeAPIClient.request(JSONAPIObject<[Channel], String>.self, endPoint: endPoint) { (result) in
            LimeAPIClient.handleJSONAPIResult(result, completion)
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
    /// let cacheKey = "test"
    /// let timeZone = TimeZone(secondsFromGMT: 3.hours)
    /// let timeZonePicker = LACTimeZonePicker.previous
    /// LimeAPIClient.requestChannelsByGroupId(cacheKey: cacheKey, timeZone: timeZone, timeZonePicker: timeZonePicker) { (result) in
    ///    switch result {
    ///    case .success(let channels):
    ///        print(channels)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func requestChannelsByGroupId(cacheKey: String = "", timeZone: TimeZone? = nil, timeZonePicker: LACTimeZonePicker = .previous, completion: @escaping DecodableCompletion<[Channel]>) {
        let defaultChannelGroupId = LimeAPIClient.configuration?.defaultChannelGroupId ?? ""
        guard !defaultChannelGroupId.isEmpty else {
            let error = APIError.unknownChannelsGroupId
            completion(.failure(error))
            guard LimeAPIClient.isVerboseEnabled else { return }
            print("\(LimeAPIClient.self)\n\(#function)\n\(error.localizedDescription)")
            return
        }
        let endPoint = EndPoint.Channels.byGroupId(
            defaultChannelGroupId,
            cacheKey: cacheKey,
            timeZone: timeZone?.utcString ?? "",
            timeZonePicker: timeZonePicker.rawValue)
        LimeAPIClient.request(JSONAPIObject<[Channel], String>.self, endPoint: endPoint) { (result) in
            LimeAPIClient.handleJSONAPIResult(result, completion)
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
    /// LimeAPIClient.requestBroadcasts(channelId: 105, dateInterval: dateInterval) { (result) in
    ///    switch result {
    ///    case .success(let broadcasts):
    ///        print(broadcasts)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func requestBroadcasts(
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
        LimeAPIClient.request(JSONAPIObject<[Broadcast], Broadcast.Meta>.self, endPoint: endPoint) { (result) in
            LimeAPIClient.handleJSONAPIResult(result, completion)
        }
    }
    
    /// Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки
    /// - Parameter key: опциональный параметр. Используется для разнообразия запросов и обхода кэша
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.ping(key: KEY) { (result) in
    ///    switch result {
    ///    case .success(let ping):
    ///        print(ping)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func ping(key: String = "", completion: @escaping DecodableCompletion<Ping>) {
        LimeAPIClient.request(Ping.self, endPoint: EndPoint.Factory.ping(key: key)) { (result) in
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
    /// // QUERY - cтрока запроса
    /// // PATH - путь запроса
    /// LimeAPIClient.deepClicks(query: QUERY, path: PATH) { (result) in
    ///    switch result {
    ///    case .success(let message):
    ///        print(message)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func deepClicks(query: String, path: String, completion: @escaping StringCompletion) {
        let endPoint = EndPoint.Factory.deepClicks(query: query, path: path)
        LimeAPIClient.request(endPoint) { (result) in
            completion(result)
        }
    }
    
    /// Запрос для получения информации о реферальной программе пользователя
    /// - Parameters:
    ///   - xToken: токен пользователя
    ///   - remoteIP: удаленный IP-адрес для тестирования
    ///   - completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// // Задание идентификаторов
    /// let identification = LACIdentification(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION)
    /// LimeAPIClient.setIdentification(identification)
    /// // Задание параметров конфигурации
    /// // Язык ожидаемого контента, который указывается запросе
    /// let language = Locale.preferredLanguages.first ?? "ru-RU"
    /// // APPLICATION_ID можно получить с помощью LACApp.id -
    /// // (идентификатор пакета, который определяется ключом CFBundleIdentifier)
    /// let configuration = LACConfiguration(language: language)
    /// LimeAPIClient.setConfiguration(configuration)
    ///
    /// // X_TOKEN - токен пользователя
    /// // REMOTE_IP - удаленный IP-адрес для тестирования (опционально)
    /// LimeAPIClient.referral(xToken: X_TOKEN, remoteIP: REMOTE_IP) { (result) in
    ///    switch result {
    ///    case .success(let referral):
    ///        print(referral)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    public static func referral(xToken: String, remoteIP: String = "", completion: @escaping DecodableCompletion<Referral>) {
        LimeAPIClient.xToken = xToken
        let endPoint = EndPoint.Factory.referral(remoteIP: remoteIP)
        LimeAPIClient.request(Referral.self, endPoint: endPoint) { (result) in
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
    /// LimeAPIClient.findBanner { (result) in
    ///    switch result {
    ///    case .success(let bannerAndDevice):
    ///        print(bannerAndDevice)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    static func findBanner(completion: @escaping DecodableCompletion<BannerAndDevice>) {
        LimeAPIClient.request(BannerAndDevice.self, endPoint: EndPoint.Banner.find()) { (result) in
            completion(result)
        }
    }
    
    /// Запрос баннера, рекомендованного данному устройству и приложению
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.nextBanner { (result) in
    ///    switch result {
    ///    case .success(let banner):
    ///        print(banner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    static func nextBanner(completion: @escaping DecodableCompletion<BannerAndDevice.Banner>) {
        LimeAPIClient.request(BannerAndDevice.Banner.self, endPoint: EndPoint.Banner.next()) { (result) in
            completion(result)
        }
    }
    
    /// Запрос на снятие (удаление) пометки "нежелательный" с баннера
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.deleteBanFromBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banBanner):
    ///        print(banBanner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    static func deleteBanFromBanner(bannerId: Int, completion: @escaping DecodableCompletion<BanBanner>) {
        let endPoint = EndPoint.Banner.deleteBan(bannerId)
        LimeAPIClient.handleBanBannerRequest(endPoint: endPoint, completion: completion)
    }
    
    /// Запрос на установку для баннер метки "нежелательный" и больше его не показывать
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.banBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banBanner):
    ///        print(banBanner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    static func banBanner(bannerId: Int, completion: @escaping DecodableCompletion<BanBanner>) {
        let endPoint = EndPoint.Banner.ban(bannerId)
        LimeAPIClient.handleBanBannerRequest(endPoint: endPoint, completion: completion)
    }
    
    /// Запрос на получение баннера (информации о нём)
    /// - Parameter bannerId: id баннера для модификации
    /// - Parameter completion: обработка результатов запроса
    ///
    /// Пример запроса:
    /// ```
    /// LimeAPIClient.getBanner(bannerId: BANNER_ID) { (result) in
    ///    switch result {
    ///    case .success(let banner):
    ///        print(banner)
    ///    case .failure(let error):
    ///        print(error)
    ///    }
    /// }
    /// ```
    static func getBanner(bannerId: Int, completion: @escaping DecodableCompletion<BannerAndDevice.Banner>) {
        LimeAPIClient.request(BannerAndDevice.Banner.self, endPoint: EndPoint.Banner.info(bannerId)) { (result) in
            completion(result)
        }
    }
    
    static func getImage(with path: String, completion: @escaping ImageCompletion) {
        LimeAPIClient.requestImage(with: path) { (result) in
            switch result {
            case .success(let image):
                LimeAPIClient.configuration?.mainQueue.async { completion(.success(image)) }
            case .failure(let error):
                LimeAPIClient.configuration?.mainQueue.async { completion(.failure(error)) }
            }
        }
    }
    
    static func getOnlinePlaylist(for streamId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let request: URLRequest
        do {
            let path = try LACStream.Online.endpoint(for: streamId)
            request = try URLRequest(path: path)
        } catch {
            completion(.failure(error))
            return
        }
        
        LimeAPIClient.requestStringData(with: request) { (result) in
            completion(result)
        }
    }
    
    static func getArchivePlaylist(for streamId: Int, startAt: Int, duration: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endPoint = EndPoint.Factory.archiveStream(for: streamId, start: startAt, duration: duration)
        let request: URLRequest
        do {
            let baseUrl = try LimeAPIClient.getBaseUrl()
            request = try URLRequest(baseUrl: baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        LimeAPIClient.requestStringData(with: request) { (result) in
            completion(result)
        }
    }
    
    private static func getBaseUrl() throws -> String {
        guard let configuration = LimeAPIClient.configuration else {
            throw APIError.emptyConfiguration
        }
        return configuration.baseUrl
    }
    
    static func getArchivePlaylist(for streamId: Int, broadcast: Broadcast, completion: @escaping (Result<String, Error>) -> Void) {
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
        LimeAPIClient.getArchivePlaylist(for: streamId, startAt: startAt, duration: duration) { (result) in
            completion(result)
        }
    }
}

//MARK: - Private Methods

typealias JSONAPIResult<T: Decodable, U: Decodable> = Result<JSONAPIObject<[T], U>, Error>

extension LimeAPIClient {
    //MARK: - Decodable Requests Methods
    
    private static func request<T: Decodable>(_ type: T.Type, endPoint: EndPoint, completion: @escaping DecodableCompletion<T>) {
        let request: URLRequest
        do {
            let baseUrl = LimeAPIClient.configuration?.baseUrl ?? ""
            request = try URLRequest(baseUrl: baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        LimeAPIClient.dataTask(with: request, T.self) { (result) in
            if case .failure(let error) = result {
                LimeAPIClient.log(request, message: error.localizedDescription)
            }
            LimeAPIClient.configuration?.mainQueue.async { completion(result) }
        }
    }
    
    private static func dataTask<T: Decodable>(with request: URLRequest, _ type: T.Type, completion: @escaping DecodableCompletion<T>) {
        let session: URLSession
        do {
            session = try LimeAPIClient.getSession()
        } catch {
            completion(.failure(error))
            return
        }
        let httpRequest = HTTPURLRequest(request: request, session: session)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        httpRequest.dataTask(decoding: T.self, decoder: decoder) { response in
            switch response {
            case .success(let result):
                LimeAPIClient.log(request, message: result.response.localizedStatusCode)
                completion(.success(result.decoded))
            case .failure(let error):
                LimeAPIClient.handleErorr(error, completion)
            }
        }
    }
    
    private static func getSession() throws -> URLSession {
        guard let configuration = LimeAPIClient.configuration else {
            throw APIError.emptyConfiguration
        }
        return configuration.session
    }
    
    private static func handleJSONAPIResult<T: Decodable, U: Decodable>(_ result: JSONAPIResult<T, U>, _ completion: @escaping DecodableCompletion<[T]>) {
        switch result {
        case let .success(result):
            completion(.success(result.data))
        case let .failure(error):
            completion(.failure(error))
        }
    }
    
    private static func handleBanBannerRequest(endPoint: EndPoint, completion: @escaping DecodableCompletion<BanBanner>) {
        LimeAPIClient.request(BanBanner.self, endPoint: endPoint) { (result) in
            completion(result)
        }
    }
    
    private static func handleErorr<T: Decodable>(_ error: Error, _ completion: @escaping DecodableCompletion<T>) {
        if let dataResponse = error.httpURLRequest?.unsuccessfulHTTPStatusCodeData {
            LimeAPIClient.decodeError(dataResponse, completion)
        } else {
            completion(.failure(error))
        }
    }
    
    private static func decodeError<T>(_ dataResponse: DataResponse, _ completion: @escaping DecodableCompletion<T>) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = dataResponse.data
        let response = dataResponse.response
        let jsonAPIErrorResult = data.decoding(type: JSONAPIError.self, decoder: decoder)
        switch jsonAPIErrorResult {
        case let .success(jsonAPIError):
            let error = APIError.jsonAPIError(response.localizedStatusCode, error: jsonAPIError)
            completion(.failure(error))
        case .failure:
            let message = data.utf8String
            let error = APIError.wrongStatusCode(response.localizedStatusCode, error: message)
            completion(.failure(error))
        }
    }
    
    //MARK: - String Request Methods
    
    private static func request(_ endPoint: EndPoint, completion: @escaping StringCompletion) {
        let request: URLRequest
        do {
            let baseUrl = try LimeAPIClient.getBaseUrl()
            request = try URLRequest(baseUrl: baseUrl, endPoint: endPoint)
        } catch {
            completion(.failure(error))
            return
        }
        
        LimeAPIClient.dataTask(with: request) { (result) in
            if case .failure(let error) = result {
                LimeAPIClient.log(request, message: error.localizedDescription)
            }
            LimeAPIClient.configuration?.mainQueue.async { completion(result) }
        }
    }
    
    private static func dataTask(with request: URLRequest, completion: @escaping StringCompletion) {
        let session: URLSession
        do {
            session = try LimeAPIClient.getSession()
        } catch {
            completion(.failure(error))
            return
        }
        let httpRequest = HTTPURLRequest(request: request, session: session)
        httpRequest.dataTask() { response in
            switch response {
            case let .success(result):
                let message = result.data.utf8String
                completion(.success(message))
            case .failure(let error):
                LimeAPIClient.handleErorr(error, completion)
            }
        }
    }
    
    //MARK: - Image Request Methods
    
    private static func requestImage(with path: String, completion: @escaping ImageCompletion) {
        let request: URLRequest
        let session: URLSession
        do {
            session = try LimeAPIClient.getSession()
            request = try URLRequest(path: path)
        } catch {
            completion(.failure(error))
            return
        }
        let httpRequest = HTTPURLRequest(request: request, session: session)
        httpRequest.dataTask() { response in
            switch response {
            case let .success(result):
                if let image = result.data.image {
                    completion(.success(image))
                } else {
                    let error = APIError.incorrectImageData
                    completion(.failure(error))
                }
            case let .failure(error):
                LimeAPIClient.log(request, message: error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    private static func requestStringData(with request: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        let session: URLSession
        do {
            session = try LimeAPIClient.getSession()
        } catch {
            completion(.failure(error))
            return
        }
        let httpRequest = HTTPURLRequest(request: request, session: session)
        httpRequest.dataTask() { response in
            switch response {
            case let .success(result):
                let playlist = result.data.utf8String
                LimeAPIClient.configuration?.mainQueue.async { completion(.success(playlist)) }
            case let .failure(error):
                LimeAPIClient.log(request, message: error.localizedDescription)
                LimeAPIClient.configuration?.mainQueue.async { completion(.failure(error)) }
            }
        }
    }
    
    private static func log(_ request: URLRequest, message: String) {
        guard LimeAPIClient.isVerboseEnabled else { return }
        let configuration = HTTP.headers.description
        let url = request.url?.absoluteString ?? "(пустое значение ulr)"
        print("\(LimeAPIClient.self) \(configuration)\n\(url)\n\(message)")
    }
}
