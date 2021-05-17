//
//  File.swift
//  
//
//  Created by Лайм HD on 17.05.2021.
//

import Foundation

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
            var errorDescription = " Неизвестная ошибка."
            if let errorTitle = error.errors.first?.title {
                errorDescription = " Ошибка: \(errorTitle)"
            }
            let key = "Неуспешный ответ состояния HTTP: \(statusCode).\(errorDescription)"
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
