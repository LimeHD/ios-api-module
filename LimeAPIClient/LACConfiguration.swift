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
    let language: String
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
