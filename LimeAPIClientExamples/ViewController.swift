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
    @IBOutlet private weak var sessionView: SessionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.session()
//        self.requestChannels()
//        self.requestChannelsByGroupId()
//        self.requestBroadcasts()
    }

    @IBAction func newSession(_ sender: Any) {
        self.sessionView.reset()
        self.session()
    }
    
    @IBAction func ping(_ sender: Any) {
        self.ping()
    }
}

extension ViewController {
    private func session() {
        // Пример cоздания новой сессии
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.session { (result) in
            switch result {
            case .success(let session):
                print(session)
                self.sessionView.set(session)
//                self.requestChannelsByGroupId()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestChannels() {
        // Пример запроса на получение списка каналов
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.requestChannels { (result) in
            switch result {
            case .success(let channels):
                print(channels)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestChannelsByGroupId() {
        // Пример запроса на получение списка каналов по id группы
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.requestChannelsByGroupId { (result) in
            switch result {
            case .success(let channels):
                print(channels)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestBroadcasts() {
        // Пример запроса на получение программы передач
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
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
    }
    
    private func ping() {
        // Пример запроса на проверку работоспособности сервиса
        // Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.ping(key: "test") { (result) in
            switch result {
            case .success(let ping):
                print(ping)
                var message = "result: \(ping.result)\n"
                message += "time: \(ping.time)\n"
                message += "version: \(ping.version)\n"
                message += "hostname: \(ping.hostname)"
                let alert = UIAlertController(title: "Успешно!", message: message)
                self.present(alert, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
