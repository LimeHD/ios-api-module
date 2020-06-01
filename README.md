# LimeAPIClient
![LimeAPIClient CI](https://github.com/LimeHD/ios-api-module/workflows/LimeAPIClient%20CI/badge.svg)
[![Build Status](https://ci.iptv2022.com/app/rest/builds/buildType:(id:IOSRoot_LimeApiClient_LimeApiClientMaster)/statusIcon)](https://ci.iptv2022.com/viewType.html?buildTypeId=IOSRoot_LimeApiClient_LimeApiClientMaster&guest=1)
![TeamCity Full Build Status](https://img.shields.io/teamcity/build/s/IOSRoot_LimeApiClient_LimeApiClientMaster?server=https%3A%2F%2Fci.iptv2022.com)
[![Maintainability](https://api.codeclimate.com/v1/badges/9cd49b797924f442e35a/maintainability)](https://codeclimate.com/repos/5e58b87660bb0c014d009f9f/maintainability)

Общий клиент для работы с API

[Спецификация к API](https://github.com/LimeHD/specs)

## Установка

Для установки используется менджер зависимостей [CocoaPods](https://cocoapods.org/). Для интеграции модуля **LimeAPIClient** в проект Xcode добавьте строку в `Podfile`:

``` ruby
pod 'LimeAPIClient', git: 'https://github.com/LimeHD/ios-api-module.git'
```

## Примеры использования
Перед использованием необходимо добавить в файл модуль `LimeAPIClient`
``` swift
import LimeAPIClient
```
Все сетевые запросы осуществляются в одельной очереди:
``` swift
DispatchQueue(label: "tv.limehd.LimeAPIClient", qos: .userInitiated, attributes: .concurrent)
```
После выполнения запроса ответ передается в главную очередь:
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

### Пример cоздания новой сессии
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

### Получение подходящего баннера для ротации
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
apiClient.findBanner { (result) in
    switch result {
    case .success(let bannerAndDevice):
        print(bannerAndDevice)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит баннер. Тип данных `BannerAndDevice`:
``` swift
struct Banner: Decodable {
    let banner: Banner
    let device: Device?
    
    struct Banner: Decodable {
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
    
    struct Device: Decodable {
        let id: String
        let shownBanners: [String : Int]
        let skippedBanners: [Int]
        let createdAt: String
        let updatedAt: String
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
В ответ приходит баннер. Тип данных `BannerAndDevice.Banner` (см. выше).

### Снятие (удаление) пометки «нежелательный» с баннера
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр BANNER_ID тип данных Int (ID Баннера для модификации)
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
// Параметр BANNER_ID тип данных Int (ID Баннера для модификации)
apiClient.banBanner(bannerId: BANNER_ID) { (result) in
    switch result {
    case .success(let banBanner):
        print(banBanner)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходит результат выполнения запроса. Тип данных `BanBanner` (см. выше)

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
    case .success(let channels):
        print(channels)
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
// Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
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
