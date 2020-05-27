//
//  ResultTableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 27.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

class ResultTableViewController: UITableViewController {
    struct ResultCell {
        let title: String
        let detail: String
    }
    
    let request: Request
    var results = [ResultCell]()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    init(request: Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureAppearance()
        self.configureActivityIndicator()
        self.addRefreshButton()
        
        self.tableView.register(SubtitleTableViewCell.self)
        
        self.requestData()
    }
    
    private func configureAppearance() {
        self.navigationController?.navigationBar.tintColor = .black
        self.title = request.rawValue
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.addCenterConstraints(equalTo: self.view)
    }
    
    private func addRefreshButton() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(requestData))
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc private func requestData() {
        self.title = self.request.rawValue
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.results = []
        self.tableView.reloadData()
        
        switch self.request {
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SubtitleTableViewCell.self, for: indexPath)

        cell?.textLabel?.text = results[indexPath.row].title
        cell?.detailTextLabel?.text = results[indexPath.row].detail
        cell?.backgroundColor = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)

        return cell ?? UITableViewCell()
    }
}

// MARK: - API Requests

extension ResultTableViewController {
    private func configureStopAnimating() {
        self.activityIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func session() {
        // Пример cоздания новой сессии
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.session { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let session):
                self.results = [
                    ResultCell(title: "session id", detail: session.sessionId),
                    ResultCell(title: "current time", detail: session.currentTime),
                    ResultCell(title: "stream endpoint", detail: session.streamEndpoint),
                    ResultCell(title: "default channel group id", detail: session.defaultChannelGroupId.string)
                ]
                self.tableView.reloadData()
                print(session)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func ping() {
        let message = "Используется для разнообразия запросов и обхода кэша (опциональный)"
        let alert = UIAlertController(title: "Параметр Key", message: message, preferredStyle: .alert)
        alert.addTextField { (_) in }
        let action = UIAlertAction(title: "Ок", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            
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
        apiClient.ping(key: key) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let ping):
                self.results = [
                    ResultCell(title: "result", detail: ping.result),
                    ResultCell(title: "time", detail: ping.time),
                    ResultCell(title: "version", detail: ping.version),
                    ResultCell(title: "hostname", detail: ping.hostname)
                ]
                self.tableView.reloadData()
                print(ping)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func requestChannels() {
        // Пример запроса на получение списка каналов
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.requestChannels { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let channels):
                self.results = channels.map { (channel) -> ResultCell in
                    ResultCell(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
                }
                self.tableView.reloadData()
                self.title = self.request.rawValue + " (\(self.results.count))"
                print(channels)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func requestChannelsByGroupId() {
        // Пример запроса на получение списка каналов по id группы
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.requestChannelsByGroupId { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let channels):
                self.results = channels.map { (channel) -> ResultCell in
                    ResultCell(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
                }
                self.tableView.reloadData()
                self.title = self.request.rawValue + " (\(self.results.count))"
                print(channels)
            case .failure(let error):
                self.showAlert(error)
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
        apiClient.requestBroadcasts(channelId: 105, dateInterval: dateInterval) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let broadcasts):
                self.results = broadcasts.map { (broadcast) -> ResultCell in
                    ResultCell(title: "id: \(broadcast.id)", detail: broadcast.attributes.title)
                }
                self.tableView.reloadData()
                self.title = self.request.rawValue + " (\(self.results.count))"
                print(broadcasts)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Ошбика", message: error.localizedDescription)
        self.present(alert, animated: true)
    }
}
