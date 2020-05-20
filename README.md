# LimeAPIClient
![LimeAPIClient CI](https://github.com/LimeHD/ios-api-module/workflows/LimeAPIClient%20CI/badge.svg)
[![Build Status](https://ci.iptv2022.com/app/rest/builds/buildType:(id:IOSRoot_LimeApiClient_LimeApiClientMaster)/statusIcon)](https://ci.iptv2022.com/viewType.html?buildTypeId=IOSRoot_LimeApiClient_LimeApiClientMaster&guest=1)

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
В ответ приходи список каналов в виде массива. Тип данных `Channel`:
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
В ответ приходи список каналов в виде массива. Тип данных `Broadcast`:
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
Ошибки приходят в виде типа данных `JSONAPIError`:
``` swift
struct JSONAPIError: Decodable, Equatable {
    let errors: [Error]
    let meta: Meta
    
    struct Error: Decodable, Equatable {
        let code: String
        let status: String
        let title: String
        let detail: String
    }
    
    struct Meta: Decodable, Equatable {
        let requestId: String
    }
}
```

### Проверка работоспособности сервиса
Пример запроса
``` swift
let apiClient = LimeAPIClient(baseUrl: BASE_URL)
// Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
apiClient.ping(key: "test") { (result) in
    switch result {
    case .success(let ping):
        print(ping)
    case .failure(let error):
        print(error)
    }
}
```
При успешном запросе в ответ приходи тип данных `Ping`:
``` swift
struct Ping: Decodable {
    let result: String
    let time: String
    let version: String
    let hostname: String
}
```