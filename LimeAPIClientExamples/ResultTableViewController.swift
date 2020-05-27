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
    enum Section: Int, CaseIterable {
        case parameters
        case results
        
        init(_ value: Int) {
            if let section = Section(rawValue: value) {
                self = section
            } else {
                self = .parameters
            }
        }
        
        var header: String {
            switch self {
            case .parameters: return "Параметры запроса"
            case .results: return "Ответ сервера"
            }
        }
    }
    
    struct RequestResult {
        let title: String
        let detail: String
    }
    
    struct RequestParameter {
        let name: String
        let detail: String
    }
    
    let request: Request
    var parameters = [RequestParameter]()
    var results = [RequestResult]()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
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

        self.registerCells()
        self.configureAppearance()
        self.hideKeyboardWhenTappedAround()
        
        switch self.request {
        case
        .sessions,
        .channels,
        .channelsByGroupId:
            break
        case .ping:
            self.parameters = [RequestParameter(name: "key", detail: "Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки")]
            return
        case .broadcasts:
            break
        }
        
        self.requestData()
    }
    
    private func registerCells() {
        self.tableView.register(fromNib: ParameterCell.self)
        self.tableView.register(SubtitleCell.self)
    }
    
    private func configureAppearance() {
        self.navigationController?.navigationBar.tintColor = .black
        self.title = request.rawValue
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)
        
        self.configureActivityIndicator()
        self.addRequestButton()
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.addCenterConstraints(equalTo: self.view)
    }
    
    private func addRequestButton() {
        let requestButton = UIBarButtonItem(title: "Запрос", style: .plain, target: self, action: #selector(requestData))
        self.navigationItem.rightBarButtonItem = requestButton
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func requestData() {
        self.title = self.request.rawValue
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.results = []
        self.tableView.reloadData()
        self.activityIndicator.startAnimating()
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = Section(section)
        switch section {
        case .parameters:
            if self.parameters.isNotEmpty {
                return section.header
            }
        case .results:
            if self.results.isNotEmpty {
                var header = section.header
                if self.request != .sessions && self.request != .ping {
                    header += " (ячеек: \(self.results.count))"
                }
                return header
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as? UITableViewHeaderFooterView
        view?.contentView.backgroundColor = .systemGreen
        view?.textLabel?.textColor = .white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(section) {
        case .parameters:
            return self.parameters.count
        case .results:
            return self.results.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(indexPath.section) {
        case .parameters:
            let cell = tableView.dequeueReusableCell(ParameterCell.self, for: indexPath)

            cell?.selectionStyle = .none
            cell?.parameterNameLabel.text = parameters[indexPath.row].name
            cell?.parameterDescriptionLabel.text = parameters[indexPath.row].detail
            cell?.backgroundColor = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)

            return cell ?? UITableViewCell()
        case .results:
            let cell = tableView.dequeueReusableCell(SubtitleCell.self, for: indexPath)

            cell?.selectionStyle = .none
            cell?.textLabel?.text = results[indexPath.row].title
            cell?.detailTextLabel?.text = results[indexPath.row].detail
            cell?.backgroundColor = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)

            return cell ?? UITableViewCell()
        }
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
                    RequestResult(title: "session id", detail: session.sessionId),
                    RequestResult(title: "current time", detail: session.currentTime),
                    RequestResult(title: "stream endpoint", detail: session.streamEndpoint),
                    RequestResult(title: "default channel group id", detail: session.defaultChannelGroupId.string)
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
        let keyIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let keyCell = self.tableView.cellForRow(at: keyIndexPath) as? ParameterCell else { return }
    
        let key = keyCell.parameterValueTextField.text ?? ""
        // Пример запроса на проверку работоспособности сервиса
        // Параметр key - опциональный. Используется для разнообразия запросов и обхода кэша
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.ping(key: key) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let ping):
                self.results = [
                    RequestResult(title: "result", detail: ping.result),
                    RequestResult(title: "time", detail: ping.time),
                    RequestResult(title: "version", detail: ping.version),
                    RequestResult(title: "hostname", detail: ping.hostname)
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
                self.results = channels.map { (channel) -> RequestResult in
                    RequestResult(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
                }
                self.tableView.reloadData()
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
                self.results = channels.map { (channel) -> RequestResult in
                    RequestResult(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
                }
                self.tableView.reloadData()
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
                self.results = broadcasts.map { (broadcast) -> RequestResult in
                    RequestResult(title: "id: \(broadcast.id)", detail: broadcast.attributes.title)
                }
                self.tableView.reloadData()
                print(broadcasts)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription)
        self.present(alert, animated: true)
    }
}
