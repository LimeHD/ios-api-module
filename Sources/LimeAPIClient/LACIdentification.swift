import Foundation

/// Идентификаторы клиента  `LimeAPIClient`.
///
/// Пример использования:
/// ```
/// // APPLICATION_ID можно получить с помощью LACApp.id -
/// // (идентификатор пакета, который определяется ключом CFBundleIdentifier)
/// let identification = LACIdentification(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION)
/// LimeAPIClient.setIdentification(identification)
/// ```
public struct LACIdentification: Equatable {
    /// Идентификатор приложения из маркета, например `limehd.ru.lite`.
    /// Значение можно получить с помощью LACApp.id - идентификатор пакета, который определяется ключом  [CFBundleIdentifier](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier).
    let appId: String
    /// Уникальный ключ приложения
    let apiKey: String
    /// Идентификатор сессии, значение получают при успешном запросе сессии.
    var sessionId = ""
    
    /// Инициализация конфигурации клиента `LimeAPIClient`
    /// - Parameters:
    ///   - appId: Идентификатор приложения из маркета, например `limehd.ru.lite`. Значение можно получить с помощью LACApp.id - идентификатор пакета, который определяется ключом [CFBundleIdentifier](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier).
    ///   - apiKey: Уникальный ключ приложения
    ///
    /// Пример использования:
    /// ```
    /// // APPLICATION_ID можно получить с помощью LACApp.id -
    /// // (идентификатор пакета, который определяется ключом CFBundleIdentifier)
    /// let identification = LACIdentification(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION)
    /// LimeAPIClient.setIdentification(identification)
    /// ```
    public init(appId: String, apiKey: String) {
        self.appId = appId
        self.apiKey = apiKey
    }
}
