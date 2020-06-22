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
- [Кэширование запросов](#%D0%BA%D1%8D%D1%88%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2)
- [Интервал времени ожидания запроса](#%D0%B8%D0%BD%D1%82%D0%B5%D1%80%D0%B2%D0%B0%D0%BB-%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%B8-%D0%BE%D0%B6%D0%B8%D0%B4%D0%B0%D0%BD%D0%B8%D1%8F-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%B0)
- [Примеры использования](#%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80%D1%8B-%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F)
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
    - [Получение ссылки на онлайн поток](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5%20%D1%81%D1%81%D1%8B%D0%BB%D0%BA%D0%B8%20%D0%BD%D0%B0%20%D0%BE%D0%BD%D0%BB%D0%B0%D0%B9%D0%BD%20%D0%BF%D0%BE%D1%82%D0%BE%D0%BA)
    - [Получение ссылки на поток архива](#%D0%9F%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5%20%D1%81%D1%81%D1%8B%D0%BB%D0%BA%D0%B8%20%D0%BD%D0%B0%20%D0%BF%D0%BE%D1%82%D0%BE%D0%BA%20%D0%B0%D1%80%D1%85%D0%B8%D0%B2%D0%B0)

<!-- /TOC -->

## Установка

Для установки используется менджер зависимостей [CocoaPods](https://cocoapods.org/). Для интеграции модуля **LimeAPIClient** в проект Xcode добавьте строку в `Podfile`:

``` ruby
pod 'LimeAPIClient', git: 'https://github.com/LimeHD/ios-api-module.git'
```

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

## Интервал времени ожидания запроса
Для запросов установлен [интервал времени ожидания](https://developer.apple.com/documentation/foundation/nsurlrequest/1418229-timeoutinterval) равный 10 сек.

## Примеры использования
Перед использованием необходимо добавить в файл модуль `LimeAPIClient`
``` swift
import LimeAPIClient
```
Все сетевые запросы осуществляются в одельном потоке (см. официальную документацию Apple по классу `URLSession` в разделе «[Asynchronicity and URL Sessions](https://developer.apple.com/documentation/foundation/urlsession/)»).
После выполнения запроса ответ передается в [главную очередь](https://developer.apple.com/documentation/dispatch/dispatchqueue/1781006-main):
``` swift
DispatchQueue.main
```

### Конфигурирование клиента
Конфигурирования клиента `LimeAPIClient` осуществлятся один раз до начала использования запросов
``` swift
let language = Locale.preferredLanguages.first ?? "ru-RU"
let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
LimeAPIClient.configuration = configuration
```

### Cоздание новой сессии
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.session { (result) in
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
struct Session: Decodable {
    let sessionId: String
    let currentTime: String
    let streamEndpoint: String
    let defaultChannelGroupId: Int
    let settings: Settings
    
    struct Settings: Decodable {
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

### Получение баннера, рекомендованного данному устройству и приложению
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.nextBanner { (result) in
    switch result {
    case .success(let banner):
        print(banner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит баннер. Тип данных `BannerAndDevice.Banner`:
``` swift
struct BannerAndDevice.Banner: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let description: String
    let isSkipable: Bool
    let type: Int
    let packId: Int?
    let detailUrl: String
    let delay: Int
}
```

### Снятие (удаление) пометки «нежелательный» с баннера
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр bannerId - ID Баннера для модификации, тип данных Int
apiClient.deleteBanFromBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banBanner):
        print(banBanner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит результат выполнения запроса. Тип данных `BanBanner`:
``` swift
struct BanBanner: Decodable {
    let result: String
}
```

### Пометить баннер как «нежелательный» и больше его не показывать
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр bannerId - ID Баннера для модификации, тип данных Int
apiClient.banBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banBanner):
        print(banBanner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит результат выполнения запроса. Тип данных `BanBanner` (см. выше).

### Получить баннер (информацию о нём)
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр bannerId - ID Баннера для модификации, тип данных Int
apiClient.getBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banner):
        print(banner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит баннер. Тип данных `BannerAndDevice.Banner` (см. выше).

### Получение списка каналов
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.requestChannels { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит список каналов в виде массива. Тип данных `Channel`:
``` swift
struct Channel: Decodable {
    let id: String
    let type: String
    let attributes: Attributes
    
    struct Attributes: Decodable {
        let name: String?
        let imageUrl: String?
        let description: String?
        let streams: [Stream]
    }
    
    struct Stream: Decodable {
        let id: Int
        let timeZone: String
        let contentType: String
    }
}
```

### Получение списка каналов по группе id
**Внимание!** Перед выполеннием запроса необходимо создать успешную новую сессию для получения параметра `defaultChannelGroupId` (см. выше).

Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.requestChannelsByGroupId { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит список каналов в виде массива. Тип данных `Channel` (см. выше).

### Получение программы передач
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
let startDate = Date().addingTimeInterval(-8.days)
let timeZone = TimeZone(secondsFromGMT: 3.hours) ?? TimeZone.current
let dateInterval = LACDateInterval(start: startDate, duration: 15.days, timeZone: timeZone)
apiClient.requestBroadcasts(channelId: 105, dateInterval: dateInterval) { (result) in
    switch result {
    case .success(let broadcasts):
        print(broadcasts)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит список каналов в виде массива. Тип данных `Broadcast`:
``` swift
struct Broadcast: Decodable {
    let id: String
    let type: String
    let attributes: Attributes
    
    struct Attributes: Decodable {
        let title: String
        let detail: String
        let rating: Int?
        let startAt: String
        let finishAt: String
    }
}
```

### Проверка работоспособности сервиса
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр key - опциональный, тип данных String. Используется для разнообразия запросов и обхода кэша
apiClient.ping(key: KEY) { (result) in
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
struct Ping: Decodable {
    let result: String
    let time: String
    let version: String
    let hostname: String
}
```

### Получение ссылки на онлайн поток
Получение ссылки для [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) на онлайн поток. Возвращает ссылку на онлайн поток в формате [`AVURLAsset`](https://developer.apple.com/documentation/avfoundation/avurlasset).

Пример запроса
``` swift
import LimeAPIClient
import AVKit

// Запрос новой сессии для получения ссылки на онлайн-поток
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.session { (result) in
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

### Получение ссылки на поток архива
Получение ссылки для [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) на поток архива. Возвращает ссылку на поток архива в формате [`AVURLAsset`](https://developer.apple.com/documentation/avfoundation/avurlasset).

Пример запроса
``` swift
import LimeAPIClient
import AVKit

// Инициализация LimeAPIClient для задания адреса сервера API
let apiClient = LimeAPIClient(baseUrl: BASE_URL)

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