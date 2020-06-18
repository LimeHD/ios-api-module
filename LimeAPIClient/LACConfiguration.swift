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
/// // APPLICATION_ID можно получить с помощью LACApp.id -
/// // (идентификатор пакета, который определяется ключом CFBundleIdentifier)
/// let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
/// LimeAPIClient.configuration = configuration
/// ```
public struct LACConfiguration {
    /// Идентификатор приложения из маркета, например `limehd.ru.lite`.
    /// Значение можно получить с помощью LACApp.id - (идентификатор пакета, который определяется ключом CFBundleIdentifier).
    let appId: String
    /// Уникальрый ключи приложения
    let apiKey: String
    /// Язык ожидаемого контента, который в указывается запросе
    ///
    /// Описание см.:  https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html#//apple_ref/doc/uid/10000171i-CH15
    let language: String
    /// Язык ожидаемого контента, который в указывается запросе в соответствии с ISO 639-1 Code / ISO 639-2 Code
    lazy var languageDesignator: String = {
        let regionDesignatorDeleted = self.language.components(separatedBy: "_").first
        let scriptDesignatorDeleted = regionDesignatorDeleted?.components(separatedBy: "-").first
        return scriptDesignatorDeleted ?? ""
    }()
    /// Идентификатор сессии, значение получают при успешном запросе сессии
    var sessionId = ""
    /// Ссылка для редиректа на текущий поток, значение получают при успешном запросе сессии
    var streamEndpoint = ""
    /// Идентификатор группы канала, значение получают при успешном запросе сессии
    var defaultChannelGroupId = ""
    
    /// Инициализация конфигурации клиента  `LimeAPIClient`
    /// - Parameters:
    ///   - appId: Идентификатор приложения из маркета, например `limehd.ru.lite`. Значение можно получить с помощью LACApp.id - (идентификатор пакета, который определяется ключом CFBundleIdentifier).
    ///   - apiKey: Уникальрый ключи приложения
    ///   - language: Язык ожидаемого контента, который в указывается запросе
    ///
    /// Пример инициализации:
    /// ```
    /// let language = Locale.preferredLanguages.first ?? "ru-RU"
    /// let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
    /// LimeAPIClient.configuration = configuration
    /// ```
    public init(appId: String, apiKey: String, language: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.language = language
    }
}
