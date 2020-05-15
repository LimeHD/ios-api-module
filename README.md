# LimeAPIClient

Общий клиент для работы с API

[Спецификация к API](https://github.com/LimeHD/specs)

## Установка

Для установки используется менджер зависимостей [CocoaPods](https://cocoapods.org/). Для интеграции модуля **LimeAPIClient** в ваш проект Xcode используя CocoaPods, добавьте строку в ваш  `Podfile`:

``` ruby
pod 'LimeAPIClient', git: 'https://github.com/LimeHD/ios-api-module.git'
```

## Примеры использования
Перед использованием необходимо добавить в файл модуль  `LimeAPIClient`
``` swift
import LimeAPIClient
```
### Получение тестовых каналов
Пример запроса
``` swift
LimeAPIClient.request([Channel].self, url: TEST_CHANNELS_URL, endPoint: .testChannels) { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходи список каналов в виде массива. Тип `Channels`:
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

### Получение cписка каналов
Пример запроса
``` swift
LimeAPIClient.request([Channel].self, url: CHANNELS_URL, endPoint: .сhannels) { (result) in
    switch result {
    case .success(let channels):
        print(channels)
    case .failure(let error):
        print(error)
    }
}
```
В ответ приходи список каналов в виде массива (тип данных `Channels` см. выше)
