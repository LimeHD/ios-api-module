//
//  LACConfiguration.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 22.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

/// Конфигурирование клиента  `LimeAPIClient`
///
/// Пример использования:
/// ```
/// // Язык ожидаемого контента, который указывается запросе
/// let language = Locale.preferredLanguages.first ?? "ru-RU"
/// let configuration = LACConfiguration(language: language)
/// LimeAPIClient.setConfiguration(configuration)
/// ```
public struct LACConfiguration {
    /// Адрес сервера API
    let baseUrl: String
    /// Координатор сетевых запросов
    let session: URLSession
    /// Очередь для отправки ответа
    let mainQueue: Dispatchable
    /// Язык ожидаемого контента, который указывается в запросе.
    ///
    /// Описание см.: [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html#//apple_ref/doc/uid/10000171i-CH15).
    let language: String
    /// Язык ожидаемого контента, который указывается в запросе в соответствии с [ISO 639-1 Code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) / [ISO 639-2 Code](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes).
    lazy var languageDesignator: String = {
        let regionDesignatorDeleted = self.language.components(separatedBy: "_").first
        let scriptDesignatorDeleted = regionDesignatorDeleted?.components(separatedBy: "-").first
        return scriptDesignatorDeleted ?? ""
    }()
    /// Ссылка для редиректа на текущий поток, значение получают при успешном запросе сессии.
    var streamEndpoint = ""
    /// Ссылка для редиректа на архивный поток, значение получают при успешном запросе сессии.
    var archiveEndpoint = ""
    /// Идентификатор группы канала, значение получают при успешном запросе сессии.
    var defaultChannelGroupId = ""
    
    /// Инициализация конфигурации клиента `LimeAPIClient`
    /// - Parameters:
    ///   - baseUrl: адрес  сервера  API
    ///   - language: язык ожидаемого контента, который указывается в запросе
    ///   - session: используется значение по умолчанию `URLSession.shared`
    ///   - mainQueue: очередь для возвращения запроса, по умолчанию используется значение `DispatchQueue.main`
    ///
    /// Пример инициализации:
    /// ```
    /// let language = Locale.preferredLanguages.first ?? "ru-RU"
    /// // BASE_URL - адрес  сервера  API
    /// let configuration = LACConfiguration(baseUrl: BASE_URL, language: language)
    /// LimeAPIClient.setConfiguration(configuration)
    /// ```
    public init(
        baseUrl: String,
        language: String,
        session: URLSession = URLSession.shared,
        mainQueue: Dispatchable = DispatchQueue.main
    ) {
        self.baseUrl = baseUrl
        self.language = language
        self.session = session
        self.mainQueue = mainQueue
    }
}
