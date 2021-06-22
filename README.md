# LimeAPIClient
![LimeAPIClient CI](https://github.com/LimeHD/ios-api-module/workflows/LimeAPIClient%20CI/badge.svg)
[![Build Status](https://ci.iptv2022.com/app/rest/builds/buildType:(id:IOSRoot_LimeApiClient_LimeApiClientMaster)/statusIcon)](https://ci.iptv2022.com/viewType.html?buildTypeId=IOSRoot_LimeApiClient_LimeApiClientMaster&guest=1)
![TeamCity Full Build Status](https://img.shields.io/teamcity/build/s/IOSRoot_LimeApiClient_LimeApiClientMaster?server=https%3A%2F%2Fci.iptv2022.com)
[![Maintainability](https://api.codeclimate.com/v1/badges/9cd49b797924f442e35a/maintainability)](https://codeclimate.com/repos/5e58b87660bb0c014d009f9f/maintainability)

Общий клиент для работы с API

[Спецификация к API](https://github.com/LimeHD/specs)

## Содержание
<!-- TOC -->

- [Содержание](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)
- [Установка](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0)
    - [CocoaPods](#CocoaPods)
    - [Swift Package Manager](#Swift-Package-Manager)
- [Сетевые запросы](#%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D0%B5-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B)
- [Кэширование запросов](#%D0%BA%D1%8D%D1%88%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2)
- [Интервал времени ожидания запроса](#%D0%B8%D0%BD%D1%82%D0%B5%D1%80%D0%B2%D0%B0%D0%BB-%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%B8-%D0%BE%D0%B6%D0%B8%D0%B4%D0%B0%D0%BD%D0%B8%D1%8F-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%B0)
- [Примеры использования](#%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80%D1%8B-%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F)
    - [Журналирование результатов запросов](#%D0%96%D1%83%D1%80%D0%BD%D0%B0%D0%BB%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D1%80%D0%B5%D0%B7%D1%83%D0%BB%D1%8C%D1%82%D0%B0%D1%82%D0%BE%D0%B2-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2)
    - [Конфигурирование клиента](#%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B8%D0%B5%D0%BD%D1%82%D0%B0)
    - [Cоздание новой сессии](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)
    - [Получение баннера, рекомендованного данному устройству и приложению](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B1%D0%B0%D0%BD%D0%BD%D0%B5%D1%80%D0%B0-%D1%80%D0%B5%D0%BA%D0%BE%D0%BC%D0%B5%D0%BD%D0%B4%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE-%D0%B4%D0%B0%D0%BD%D0%BD%D0%BE%D0%BC%D1%83-%D1%83%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D1%83-%D0%B8-%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8E)
    - [Снятие (удаление) пометки «нежелательный» с баннера](#%D1%81%D0%BD%D1%8F%D1%82%D0%B8%D0%B5-%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BF%D0%BE%D0%BC%D0%B5%D1%82%D0%BA%D0%B8-%C2%AB%D0%BD%D0%B5%D0%B6%D0%B5%D0%BB%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9%C2%BB-%D1%81-%D0%B1%D0%B0%D0%BD%D0%BD%D0%B5%D1%80%D0%B0)
    - [Пометить баннер как «нежелательный» и больше его не показывать](#%D0%BF%D0%BE%D0%BC%D0%B5%D1%82%D0%B8%D1%82%D1%8C-%D0%B1%D0%B0%D0%BD%D0%BD%D0%B5%D1%80-%D0%BA%D0%B0%D0%BA-%C2%AB%D0%BD%D0%B5%D0%B6%D0%B5%D0%BB%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9%C2%BB-%D0%B8-%D0%B1%D0%BE%D0%BB%D1%8C%D1%88%D0%B5-%D0%B5%D0%B3%D0%BE-%D0%BD%D0%B5-%D0%BF%D0%BE%D0%BA%D0%B0%D0%B7%D1%8B%D0%B2%D0%B0%D1%82%D1%8C)
    - [Получить баннер (информацию о нём)](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B8%D1%82%D1%8C-%D0%B1%D0%B0%D0%BD%D0%BD%D0%B5%D1%80-%D0%B8%D0%BD%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%86%D0%B8%D1%8E-%D0%BE-%D0%BD%D1%91%D0%BC)
    - [Получение списка каналов](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%BF%D0%B8%D1%81%D0%BA%D0%B0-%D0%BA%D0%B0%D0%BD%D0%B0%D0%BB%D0%BE%D0%B2)
    - [Получение списка каналов по группе id](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D1%81%D0%BF%D0%B8%D1%81%D0%BA%D0%B0-%D0%BA%D0%B0%D0%BD%D0%B0%D0%BB%D0%BE%D0%B2-%D0%BF%D0%BE-%D0%B3%D1%80%D1%83%D0%BF%D0%BF%D0%B5-id)
    - [Получение программы передач](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B-%D0%BF%D0%B5%D1%80%D0%B5%D0%B4%D0%B0%D1%87)
    - [Проверка работоспособности сервиса](#%D0%BF%D1%80%D0%BE%D0%B2%D0%B5%D1%80%D0%BA%D0%B0-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BE%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1%D0%BD%D0%BE%D1%81%D1%82%D0%B8-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%B0)
    - [Получение AVURLAsset на онлайн поток](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-AVURLAsset-%D0%BD%D0%B0-%D0%BE%D0%BD%D0%BB%D0%B0%D0%B9%D0%BD-%D0%BF%D0%BE%D1%82%D0%BE%D0%BA)
    - [Получение URLRequest на онлайн поток](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-URLRequest-%D0%BD%D0%B0-%D0%BE%D0%BD%D0%BB%D0%B0%D0%B9%D0%BD-%D0%BF%D0%BE%D1%82%D0%BE%D0%BA)
    - [Получение AVURLAsset на поток архива](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-AVURLAsset-%D0%BD%D0%B0-%D0%BF%D0%BE%D1%82%D0%BE%D0%BA-%D0%B0%D1%80%D1%85%D0%B8%D0%B2%D0%B0)
    - [Получение AVURLAsset на поток архива с помощью broadcast](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-AVURLAsset-%D0%BD%D0%B0-%D0%BF%D0%BE%D1%82%D0%BE%D0%BA-%D0%B0%D1%80%D1%85%D0%B8%D0%B2%D0%B0-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-broadcast)
    - [Запрос deep clicks](#%D0%97%D0%B0%D0%BF%D1%80%D0%BE%D1%81-deep-clicks)
    - [Получение информации о реферальной программе пользователя](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B8%D0%BD%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%86%D0%B8%D0%B8-%D0%BE-%D1%80%D0%B5%D1%84%D0%B5%D1%80%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B9-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B5-%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F)

<!-- /TOC -->

## Установка
### CocoaPods
Для установки используется менджер зависимостей [CocoaPods](https://cocoapods.org/). Для интеграции модуля **LimeAPIClient** в проект Xcode добавьте строки в `Podfile`:

``` ruby
pod 'LimeAPIClient', git: 'https://github.com/LimeHD/ios-api-module.git'
pod 'Networker', git: 'https://github.com/SwiftExtensions/HTTPURLRequest.git'
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)
### Swift Package Manager
Для добавления зависимости в ваш Xcode проект, выберите File > Swift Packages > Add Package Dependency и укажите URL репозитория `LimeAPIClient`:
```
https://github.com/LimeHD/ios-api-module.git
```
Для более подробной информации, см. [`Adding Package Dependencies to Your App`](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)
## Сетевые запросы
Сетевые запросы осуществляются с помощью стандартной библиотеки Apple [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession) (также см. «[URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)»). При инициализации клиента есть возможность задания собственного экзепляра URLSession. По умолчанию используется синглтон [`URLSession.shared`](https://developer.apple.com/documentation/foundation/urlsession/1409000-shared).

Для сетевых запросов используется метод [`dataTask(with:completionHandler:)`](https://developer.apple.com/documentation/foundation/urlsession/1407613-datatask).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

## Кэширование запросов
Кэширование запросов осуществляется в соответсвии параметром политики кэширования установленным для 
[`URLRequest`](https://developer.apple.com/documentation/foundation/urlrequest) по умолчанию  [`NSURLRequest.CachePolicy.useProtocolCachePolicy`](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy):
> ## HTTP Cacheing Behavior
> For the HTTP and HTTPS protocols, NSURLRequest.CachePolicy.useProtocolCachePolicy performs the following behavior:
> 1. If a cached response does not exist for the request, the URL loading system fetches the data from the originating source.
> 2. Otherwise, if the cached response does not indicate that it must be revalidated every time, and if the cached response is not stale (past its expiration date), the URL loading system returns the cached response.
> 3. If the cached response is stale or requires revalidation, the URL loading system makes a HEAD request to the originating source to see if the resource has changed. If so, the URL loading system fetches the data from the originating source. Otherwise, it returns the cached response.
>
>
> For the formal definition of these semantics, see [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13).

Размер кэша в соответствии с установленными по умолчанию значениями для [`URLCache.shared`](https://developer.apple.com/documentation/foundation/urlcache/1413377-shared).  
Для более подробной информации см. документацию Apple: [Accessing Cached Data](https://developer.apple.com/documentation/foundation/url_loading_system/accessing_cached_data).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

## Интервал времени ожидания запроса
Для запросов установлен [интервал времени ожидания](https://developer.apple.com/documentation/foundation/nsurlrequest/1418229-timeoutinterval) равный 10 сек.

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

## Примеры использования
Перед использованием необходимо добавить в файл модуль `LimeAPIClient`
``` swift
import LimeAPIClient
```
Все сетевые запросы осуществляются в одельном потоке (см. официальную документацию Apple по классу `URLSession` в разделе «[Asynchronicity and URL Sessions](https://developer.apple.com/documentation/foundation/urlsession/)»).
После выполнения запроса ответ передается в главную очередь [`DispatchQueue.main`](https://developer.apple.com/documentation/dispatch/dispatchqueue/1781006-main).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Журналирование результатов запросов
По умолчанию журналирование результов запросов отключено. Для включения нужно выполнить команду:
``` swift
LimeAPIClient.verbose()
```

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Конфигурирование клиента
Конфигурирования клиента `LimeAPIClient` осуществлятся один раз до начала использования запросов
``` swift
let identification = LACIdentification(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION)
LimeAPIClient.setIdentification(identification)
let language = Locale.preferredLanguages.first ?? "ru-RU"
let configuration = LACConfiguration(baseUrl: BASE_URL, language: language)
LimeAPIClient.setConfiguration(configuration)
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Cоздание новой сессии
``` swift
LimeAPIClient.session { (result) in
    switch result {
    case .success(let session):
        print(session)
    case .failure(let error):
        print(error)
    }
}
```
При успешном запросе в ответ приходит тип данных `Session`:
``` swift
struct Session: Decodable, Equatable {
    let sessionId: String
    let currentTime: String
    let streamEndpoint: String
  	let archiveEndpoint: String
    let defaultChannelGroupId: Int
    let settings: Settings
    
    struct Settings: Decodable, Equatable {
        let isAdStart: Bool
        let isAdFirstStart: Bool
        let isAdOnlStart: Bool
        let isAdArhStart: Bool
        let isAdOnlOut: Bool
        let isAdArhOut: Bool
        let isAdOnlFullOut: Bool
        let isAdArhFullOut: Bool
        let isAdArhPauseOut: Bool
        let adMinTimeout: Int
    }
  	
  	struct Meta: Decodable, Equatable {
        let policyId: Int
    }
}
```
Все ошибки в ответе сервера приходят в виде типа данных `JSONAPIError`:
``` swift
struct JSONAPIError: Decodable, Equatable {
    let errors: [Error]
    let meta: Meta
    
    struct Error: Decodable, Equatable {
        let id: Int?
        let status: String
        let code: String
        let title: String
        let detail: String?
    }

    struct Meta: Decodable, Equatable {
        let requestId: String
    }
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение баннера, рекомендованного данному устройству и приложению
Пример запроса
``` swift
LimeAPIClient.nextBanner { (result) in
    switch result {
    case .success(let banner):
        print(banner)
    case .failure(let error):
        print(error)
    }
}
```
<a id="banner-and-device-banner"></a>В ответ приходит баннер. Тип данных `BannerAndDevice.Banner`:
``` swift
struct BannerAndDevice.Banner: Decodable, Equatable {
    let id: Int
    let imageUrl: String
    let title: String
    let description: String
    let isSkipable: Bool
    let type: Int
    let packId: Int?
    let detailUrl: String
    let delay: Int
    let buttonText: String
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Снятие (удаление) пометки «нежелательный» с баннера
Пример запроса
``` swift
// Параметр bannerId - ID Баннера для модификации, тип данных Int
LimeAPIClient.deleteBanFromBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banBanner):
        print(banBanner)
    case .failure(let error):
        print(error)
    }
}
```
<a id="banbanner"></a>В ответ приходит результат выполнения запроса. Тип данных `BanBanner`:
``` swift
struct BanBanner: Decodable, Equatable {
    let result: String
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Пометить баннер как «нежелательный» и больше его не показывать
Пример запроса
``` swift
// Параметр bannerId - ID Баннера для модификации, тип данных Int
LimeAPIClient.banBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banBanner):
        print(banBanner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит результат выполнения запроса. Тип данных `BanBanner` ([см. выше](#banbanner)).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получить баннер (информацию о нём)
Пример запроса
``` swift
// Параметр bannerId - ID Баннера для модификации, тип данных Int
LimeAPIClient.getBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banner):
        print(banner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит баннер. Тип данных `BannerAndDevice.Banner` ([см. выше](#banner-and-device-banner)).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение списка каналов
Пример запроса
``` swift
LimeAPIClient.requestChannels { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
<a id="channel"></a>В ответ приходит список каналов в виде массива. Тип данных `Channel`:
``` swift
struct Channel: Decodable, Equatable {
    let id: String
    let type: String
    let attributes: Attributes
    
    struct Attributes: Decodable, Equatable {
        let name: String?
        let imageUrl: String?
        let description: String?
        let streams: [Stream]
    }
    
    struct Stream: Decodable, Equatable {
        let id: Int
        let timeZone: String
        let archiveHours: Int
        let contentType: String?
    }
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение списка каналов по группе id
> **Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения параметра `defaultChannelGroupId` ([см. выше](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)).

Пример запроса
``` swift
let cacheKey = "test"
let timeZone = TimeZone(secondsFromGMT: 3.hours)
let timeZonePicker = LACTimeZonePicker.previous
LimeAPIClient.requestChannelsByGroupId(cacheKey: cacheKey, timeZone: timeZone, timeZonePicker: timeZonePicker) { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит список каналов в виде массива. Тип данных `Channel` ([см. выше](#channel)).

[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение программы передач
Пример запроса
``` swift
let startDate = Date().addingTimeInterval(-8.days)
let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
let dateInterval = LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
LimeAPIClient.requestBroadcasts(channelId: 105, dateInterval: dateInterval) { (result) in
    switch result {
    case .success(let broadcasts):
        print(broadcasts)
    case .failure(let error):
        print(error)
    }
}
```
<a id="broadcast"></a>В ответ приходит список телепередач в виде массива. Тип данных `Broadcast`:
``` swift
struct Broadcast: Decodable, Equatable {
    let id: String
    let type: String
    let attributes: Attributes
    var startAtUnix: Int? { get }
    var duration: Int? { get }
    
    struct Attributes: Decodable, Equatable {
        let title: String
        let detail: String
        let rating: Int?
        let startAt: String
        let finishAt: String
    }
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Проверка работоспособности сервиса
Пример запроса
``` swift
// Параметр key - опциональный, тип данных String, 
// используется для разнообразия запросов и обхода кэша
LimeAPIClient.ping(key: KEY) { (result) in
    switch result {
    case .success(let ping):
        print(ping)
    case .failure(let error):
        print(error)
    }
}
```
При успешном запросе в ответ приходит тип данных `Ping`:
``` swift
struct Ping: Decodable, Equatable {
    let result: String
    let time: String
    let version: String
    let hostname: String
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение AVURLAsset на онлайн поток
> **Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения  общей ссылки на онлайн потоки ([см. выше](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)).

Получение ссылки для [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) на онлайн поток. Возвращает ссылку на онлайн поток в формате [`AVURLAsset`](https://developer.apple.com/documentation/avfoundation/avurlasset).

Пример запроса
``` swift
import LimeAPIClient
import AVKit

// Запрос новой сессии для получения ссылки на онлайн-поток
LimeAPIClient.session { (result) in
   switch result {
   case .success(let session):
       print(session)
   case .failure(let error):
       print(error)
   }
}

let streamId = 44
let asset: AVURLAsset
do {
    asset = try LACStream.Online.urlAsset(for: streamId)
} catch {
    print(error)
    return
}
let playerItem = AVPlayerItem(asset: asset)
let player = AVPlayer(playerItem: playerItem)
let playerViewController = AVPlayerViewController()
playerViewController.player = player
self.present(playerViewController, animated: true) {
    playerViewController.player!.play()
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение URLRequest на онлайн поток
> **Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения  общей ссылки на онлайн потоки ([см. выше](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)).

Получение URL-запроса на онлайн поток [`URLRequest`](https://developer.apple.com/documentation/foundation/urlrequest) для использования в [`WKWebView`](https://developer.apple.com/documentation/webkit/wkwebview).

Пример запроса
``` swift
iimport LimeAPIClient
// Запрос новой сессии для получения ссылки на онлайн-поток
LimeAPIClient.session { (result) in
   switch result {
   case .success(let session):
       print(session)
   case .failure(let error):
       print(error)
   }
}

let streamId = 44
let request: URLRequest
do {
    request = try LACStream.Online.request(for: streamId)
} catch {
    print(error)
    return
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение AVURLAsset на поток архива
> **Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения  общей ссылки на архивные потоки ([см. выше](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)).

Получение ссылки для [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) на поток архива. Возвращает ссылку на поток архива в формате [`AVURLAsset`](https://developer.apple.com/documentation/avfoundation/avurlasset).

Пример запроса
``` swift
import LimeAPIClient
import AVKit

// Запрос новой сессии для получения ссылки на архивный поток
LimeAPIClient.session { (result) in
    switch result {
    case .success(let session):
        print(session)
    case .failure(let error):
        print(error)
    }
}

let streamId = 44
let start = 1592568300
let duration = 5580
let asset: AVURLAsset
do {
    asset = try LACStream.Archive.urlAsset(for: streamId, start: start, duration: duration)
} catch {
    print(error)
    return
}
let playerItem = AVPlayerItem(asset: asset)
let player = AVPlayer(playerItem: playerItem)
let playerViewController = AVPlayerViewController()
playerViewController.player = player
self.present(playerViewController, animated: true) {
    playerViewController.player!.play()
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение AVURLAsset на поток архива с помощью broadcast

> **Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения  общей ссылки на архивные потоки ([см. выше](#c%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8)).

После получения [программы передач](#%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B-%D0%BF%D0%B5%D1%80%D0%B5%D0%B4%D0%B0%D1%87) можно непосредственно использовать полученные данные для получения ссылки для [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) на поток архива. Метод возвращает ссылку на поток архива в формате [`AVURLAsset`](https://developer.apple.com/documentation/avfoundation/avurlasset). Описание типа данных `Broadcast` [см. выше](#broadcast).

Пример запроса
``` swift
import LimeAPIClient
import AVKit

// Запрос новой сессии для получения ссылки на архивный поток
LimeAPIClient.session { (result) in
    switch result {
    case .success(let session):
        print(session)
    case .failure(let error):
        print(error)
    }
}

let streamId = 44
let asset: AVURLAsset
do {
    asset = try LACStream.Archive.urlAsset(for: streamId, broadcast: broadcast)
} catch {
    print(error)
    return
}
let playerItem = AVPlayerItem(asset: asset)
let player = AVPlayer(playerItem: playerItem)
let playerViewController = AVPlayerViewController()
playerViewController.player = player
self.present(playerViewController, animated: true) {
    playerViewController.player!.play()
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Запрос deep clicks

Отправка запроса на создание `deep clicks` - отправка сообщения об установке по реферальной ссылке. При успешном запросе в ответ приходит тип данных [`String`](https://developer.apple.com/documentation/swift/string).

Пример запроса
``` swift
import LimeAPIClient

// QUERY - cтрока запроса
// PATH - путь запроса
LimeAPIClient.deepClicks(query: QUERY, path: PATH) { (result) in
   switch result {
   case .success(let message):
       print(message)
   case .failure(let error):
       print(error)
   }
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)

### Получение информации о реферальной программе пользователя

Пример запроса
``` swift
import LimeAPIClient

// X_TOKEN - токен пользователя
// REMOTE_IP - удаленный IP-адрес для тестирования (опционально)
LimeAPIClient.referral(xToken: X_TOKEN, remoteIP: REMOTE_IP) { (result) in
    switch result {
    case .success(let referral):
        print(referral)
    case .failure(let error):
        print(error)
    }
}
```
При успешном запросе в ответ приходит тип данных `Referral`:
``` swift
struct Referral: Decodable, Equatable {
    let currentTime: String
    let shareUrl: String
    let userReferralUrl: String
    let userReferralUrlExpiredAt: String
    let referralsCount: Int
}
```
[К содержанию](#%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D0%BD%D0%B8%D0%B5)