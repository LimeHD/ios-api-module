//
//  APIRequest.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

enum APIRequest: String {
    case sessions
    case ping
    case findBanner = "find banner"
    case nextBanner = "next banner"
    case deleteBanFromBanner = "delete ban from banner"
    case banBanner = "ban banner"
    case getBanner = "get banner"
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
        case .nextBanner:
            return "Рекомендованные данному устройству и приложению баннеры"
        case .deleteBanFromBanner:
            return "Снять (удалить) пометку «нежелательный» с баннера"
        case .banBanner:
            return "Пометить баннер как «нежелательный» и больше его не показывать"
        case .getBanner:
            return "Получить баннер (информацию о нём)"
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
        let keyboardType: UIKeyboardType
    }
    
    struct Result {
        let title: String
        let detail: String
        let imageUrl: String?
        
        init(title: String, detail: String, imageUrl: String? = nil) {
            self.title = title
            self.detail = detail
            self.imageUrl = imageUrl
        }
    }
    
    struct Results {
        private init() { }
    }
}

extension APIRequest.Results {
    static func create(from session: Session) -> [APIRequest.Result] {
        let settings = session.settings
        return [
            APIRequest.Result(title: "session id", detail: session.sessionId),
            APIRequest.Result(title: "current time", detail: session.currentTime),
            APIRequest.Result(title: "stream endpoint", detail: session.streamEndpoint),
            APIRequest.Result(title: "default channel group id", detail: session.defaultChannelGroupId.string),
            APIRequest.Result(title: "is ad start: \(settings.isAdStart)", detail: "Показывать рекламу при старте приложения"),
            APIRequest.Result(title: "is ad first start: \(settings.isAdFirstStart)",
                detail: "Показывать рекламу при первом старте приложения"),
            APIRequest.Result(title: "is ad onl start: \(settings.isAdOnlStart)",
                detail: "Показывать рекламу при включении онлайн-трансляции"),
            APIRequest.Result(title: "is ad arh start: \(settings.isAdArhStart)",
                detail: "Показывать рекламу при включении трансляции архива"),
            APIRequest.Result(title: "is ad onl out: \(settings.isAdOnlOut)",
                detail: "Показывать рекламу при выключении онлайн-трансляции"),
            APIRequest.Result(title: "is ad arh out: \(settings.isAdArhOut)",
                detail: "Показывать рекламу при выключении трансляции архива"),
            APIRequest.Result(title: "is ad onl full out: \(settings.isAdOnlFullOut)",
                detail: "Показывать рекламу при выходе из полного экрана в онлайн-трансляции"),
            APIRequest.Result(title: "is ad arh full out: \(settings.isAdArhFullOut)",
                detail: "Показывать рекламу при выходе из полного экрана в трансляции архива"),
            APIRequest.Result(title: "is ad arh pause out: \(settings.isAdArhPauseOut)",
                detail: "Показывать рекламу при выходе из паузы при трансляции архива"),
            APIRequest.Result(title: "ad min timeout: \(settings.adMinTimeout)",
                detail: "Следующаяя реклама покажется не раньше чем через это количество секунд")
        ]
    }
    
    static func create(from ping: Ping) -> [APIRequest.Result] {
        [
            APIRequest.Result(title: "result", detail: ping.result),
            APIRequest.Result(title: "time", detail: ping.time),
            APIRequest.Result(title: "version", detail: ping.version),
            APIRequest.Result(title: "hostname", detail: ping.hostname)
        ]
    }
    
    static func create(from banner: BannerAndDevice.Banner) -> [APIRequest.Result] {
        [
            APIRequest.Result(title: "id", detail: banner.id.string),
            APIRequest.Result(title: "image url", detail: banner.imageUrl, imageUrl: banner.imageUrl),
            APIRequest.Result(title: "title", detail: banner.title),
            APIRequest.Result(title: "description", detail: banner.description),
            APIRequest.Result(title: "is skipable", detail: banner.isSkipable.string),
            APIRequest.Result(title: "type", detail: banner.type.string),
            APIRequest.Result(title: "pack id", detail: banner.packId?.string ?? "null"),
            APIRequest.Result(title: "detail url", detail: banner.detailUrl),
            APIRequest.Result(title: "delay", detail: banner.delay.string)
        ]
    }
    
    static func create(from bannerAndDevice: BannerAndDevice) -> [APIRequest.Result] {
        var results = APIRequest.Results.create(from: bannerAndDevice.banner)
        if let device = bannerAndDevice.device {
            results += [
                APIRequest.Result(title: "device id", detail: device.id),
                APIRequest.Result(title: "shown banners", detail: "\(device.shownBanners)"),
                APIRequest.Result(title: "skipped banners", detail: "\(device.skippedBanners)"),
                APIRequest.Result(title: "created at", detail: device.createdAt),
                APIRequest.Result(title: "updated at", detail: device.updatedAt)
            ]
        }
        
        return results
    }
    
    static func create(from channels: [Channel]) -> [APIRequest.Result] {
        channels.map { (channel) -> APIRequest.Result in
            APIRequest.Result(title: "id: \(channel.id)", detail: channel.attributes.name ?? "", imageUrl: channel.attributes.imageUrl)
        }
    }
    
    static func create(from error: JSONAPIError.Error) -> [APIRequest.Result] {
        [
            APIRequest.Result(title: "id", detail: error.id?.string ?? "-"),
            APIRequest.Result(title: "status", detail: error.status),
            APIRequest.Result(title: "code", detail: error.code),
            APIRequest.Result(title: "title", detail: error.title),
            APIRequest.Result(title: "detail", detail: error.detail ?? "nil")
        ]
    }
}
