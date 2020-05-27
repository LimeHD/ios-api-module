//
//  APITableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

class APITableViewController: UITableViewController {
    struct API {
        let title: String
        let requests: [Requests]
    }
    
    enum Requests: String {
        case sessions
        case ping
        case channels
        case channelsByGroupId = "channels by group id"
        case broadcasts
    }
    
    var apiList = [API]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiList = [
            API(title: "sessions", requests: [.sessions]),
            API(title: "ping", requests: [.ping]),
            API(title: "channels", requests: [.channels, .channelsByGroupId]),
            API(title: "broadcasts", requests: [.broadcasts])
        ]
        
        self.removeExtraEmptyCells()
    }
    
    private func removeExtraEmptyCells() {
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.apiList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.apiList[section].title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as? UITableViewHeaderFooterView
        view?.contentView.backgroundColor = .systemGreen
        view?.textLabel?.textColor = .white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.apiList[section].requests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.apiList[indexPath.section].requests[indexPath.row].rawValue
        let button = AccessoryButton(title: "Запрос", indexPath: indexPath, tintColor: .black)
        button.addTarget(self, action: #selector(request(_:)), for: .touchUpInside)
        cell.accessoryView = button
        
        return cell
    }
    
    @objc private func request(_ sender: AccessoryButton) {
        guard
            let cell = self.tableView.cellForRow(at: sender.indexPath),
            let cellText = cell.textLabel?.text,
            let request = Requests(rawValue: cellText)
        else { return }
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.startAnimating()
        cell.accessoryView = indicator
        
        switch request {
        case .sessions:
            self.session()
        case .ping:
            self.ping()
        case .channels:
            self.requestChannels()
        case .channelsByGroupId:
            self.requestChannelsByGroupId()
        case .broadcasts:
            self.requestBroadcasts()
        }
    }

}

// MARK: - API Requests

extension APITableViewController {
    private func session() {
        // Пример cоздания новой сессии
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.session { (result) in
            switch result {
            case .success(let session):
                print(session)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func ping() {
        let message = "Используется для разнообразия запросов и обхода кэша (опциональный)"
        let alert = UIAlertController(title: "Параметр Key", message: message, preferredStyle: .alert)
        alert.addTextField { (_) in }
        let action = UIAlertAction(title: "Ок", style: .default) { (_) in
            let key = alert.textFields?.first?.text
            self.ping(key: key ?? "")
        }
        alert.addAction(action)
        alert.preferredAction = action
        self.present(alert, animated: true)
    }
    
    private func ping(key: String) {
        // Пример запроса на проверку работоспособности сервиса
        // Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.ping(key: key) { (result) in
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
}
