//
//  APIRequest.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

enum APIRequest: String {
    case sessions
    case ping
    case findBanner = "find banner"
    case channels
    case channelsByGroupId = "channels by group id"
    case broadcasts
    
    var detail: String {
        switch self {
        case .sessions:
            return "Создаёт новую сессию"
        case .ping:
            return "Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки"
        case .findBanner:
            return "Отдает на проверку подходящий баннер без ротации"
        case .channels:
            return "Полный список доступных каналов"
        case .channelsByGroupId:
            return "Cписок доступных каналов в соответствии с группой id"
        case .broadcasts:
            return "Программа передач"
        }
    }
    
    struct Parameter {
        let name: String
        let detail: String
    }
    
    struct Result {
        let title: String
        let detail: String
    }
}
