//
//  ViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Пример запроса на получение списка каналов
        let apiClient = LimeAPIClient(baseUrl: BASE_URL)
        apiClient.requestChannels { (result) in
            switch result {
            case .success(let channels):
                print(channels)
            case .failure(let error):
                print(error)
            }
        }
        
        // Пример запроса на получение программы передач
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
        
        // Пример запроса на проверку работоспособности сервиса
        // Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
        apiClient.ping(key: "test") { (result) in
            switch result {
            case .success(let ping):
                print(ping)
            case .failure(let error):
                print(error)
            }
        }
    }

}

