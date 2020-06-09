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
    
    let request: APIRequest
    var parameters = [APIRequest.Parameter]()
    var results = [APIRequest.Result]()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    init(request: APIRequest) {
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
        .findBanner,
        .nextBanner,
        .channels,
        .channelsByGroupId:
            break
        case
        .deleteBanFromBanner,
        .banBanner,
        .getBanner:
            self.parameters = [APIRequest.Parameter(name: "banner id", detail: "Id баннера для модификации", keyboardType: .numberPad)]
            return
        case .ping:
            self.parameters = [APIRequest.Parameter(name: "key", detail: "Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки", keyboardType: .URL)]
            return
        case .broadcasts:
            break
        }
        
        self.requestData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ColorTheme.setMode(.success)
        self.navigationController?.navigationBar.barTintColor = ColorTheme.Background.header
    }
    
    private func registerCells() {
        self.tableView.register(fromNib: ParameterCell.self)
        self.tableView.register(SubtitleCell.self)
    }
    
    private func configureAppearance() {
        self.navigationController?.navigationBar.tintColor = .black
        self.title = self.request.rawValue
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = ColorTheme.Background.view
        
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
        self.changeColorTheme(.success)
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
        case .findBanner:
            self.findBanner()
        case .nextBanner:
            self.nextBanner()
        case .deleteBanFromBanner:
            self.deleteBanFromBanner()
        case .banBanner:
            self.banBanner()
        case .getBanner:
            self.getBanner()
        case .channels:
            self.requestChannels()
        case .channelsByGroupId:
            self.requestChannelsByGroupId()
        case .broadcasts:
            self.requestBroadcasts()
        }
    }
    
    private func changeColorTheme(_ mode: ColorTheme.Mode) {
        ColorTheme.setMode(mode)
        self.navigationController?.navigationBar.barTintColor = ColorTheme.Background.header
        self.view.backgroundColor = ColorTheme.Background.view
    }
}

// MARK: - Table view data source

extension ResultTableViewController {
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
                if ColorTheme.mode == .failure { return header }
                
                switch self.request {
                case
                .sessions,
                .ping,
                .findBanner,
                .nextBanner,
                .deleteBanFromBanner,
                .banBanner,
                .getBanner:
                    break
                default:
                    header += " (ячеек: \(self.results.count))"
                }
                return header
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as? UITableViewHeaderFooterView
        view?.contentView.backgroundColor = ColorTheme.Background.header
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
            cell?.parameterValueTextField.keyboardType = parameters[indexPath.row].keyboardType
            cell?.parameterDescriptionLabel.text = parameters[indexPath.row].detail
            cell?.backgroundColor = ColorTheme.Background.view

            return cell ?? UITableViewCell()
        case .results:
            let cell = tableView.dequeueReusableCell(SubtitleCell.self, for: indexPath)

            cell?.selectionStyle = .none
            cell?.textLabel?.text = results[indexPath.row].title
            cell?.detailTextLabel?.text = results[indexPath.row].detail
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.backgroundColor = ColorTheme.Background.view

            return cell ?? UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath),
            let path = cell.detailTextLabel?.text,
            let url = URL(string: path)
        else { return }
        UIApplication.shared.open(url: url)
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
                    APIRequest.Result(title: "session id", detail: session.sessionId),
                    APIRequest.Result(title: "current time", detail: session.currentTime),
                    APIRequest.Result(title: "stream endpoint", detail: session.streamEndpoint),
                    APIRequest.Result(title: "default channel group id", detail: session.defaultChannelGroupId.string),
                    APIRequest.Result(title: "is ad start: \(session.settings.isAdStart)", detail: "Показывать рекламу при старте приложения"),
                    APIRequest.Result(title: "is ad first start: \(session.settings.isAdFirstStart)", detail: "Показывать рекламу при первом старте приложения"),
                    APIRequest.Result(title: "is ad onl start: \(session.settings.isAdOnlStart)", detail: "Показывать рекламу при включении онлайн-трансляции"),
                    APIRequest.Result(title: "is ad arh start: \(session.settings.isAdArhStart)", detail: "Показывать рекламу при включении трансляции архива"),
                    APIRequest.Result(title: "is ad onl out: \(session.settings.isAdOnlOut)", detail: "Показывать рекламу при выключении онлайн-трансляции"),
                    APIRequest.Result(title: "is ad arh out: \(session.settings.isAdArhOut)", detail: "Показывать рекламу при выключении трансляции архива"),
                    APIRequest.Result(title: "is ad onl full out: \(session.settings.isAdOnlFullOut)", detail: "Показывать рекламу при выходе из полного экрана в онлайн-трансляции"),
                    APIRequest.Result(title: "is ad arh full out: \(session.settings.isAdArhFullOut)", detail: "Показывать рекламу при выходе из полного экрана в трансляции архива"),
                    APIRequest.Result(title: "is ad arh pause out: \(session.settings.isAdArhPauseOut)", detail: "Показывать рекламу при выходе из паузы при трансляции архива"),
                    APIRequest.Result(title: "ad min timeout: \(session.settings.adMinTimeout)", detail: "Следующаяя реклама покажется не раньше чем через это количество секунд")
                ]
                self.tableView.reloadData()
                print(session)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func findBanner() {
        // Пример запроса подходящего баннер без ротации
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.findBanner { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let bannerAndDevice):
                self.configureBannerResult(bannerAndDevice.banner)
                if let device = bannerAndDevice.device {
                    self.results += [
                        APIRequest.Result(title: "device id", detail: device.id),
                        APIRequest.Result(title: "shown banners", detail: "\(device.shownBanners)"),
                        APIRequest.Result(title: "skipped banners", detail: "\(device.skippedBanners)"),
                        APIRequest.Result(title: "created at", detail: device.createdAt),
                        APIRequest.Result(title: "updated at", detail: device.updatedAt)
                    ]
                }
                self.tableView.reloadData()
                print(bannerAndDevice)
            case .failure(let error):
                self.showAlert(error)
                print(error)
            }
        }
    }
    
    private func configureBannerResult(_ banner: BannerAndDevice.Banner) {
        self.results = [
            APIRequest.Result(title: "id", detail: banner.id.string),
            APIRequest.Result(title: "image url", detail: banner.imageUrl),
            APIRequest.Result(title: "title", detail: banner.title),
            APIRequest.Result(title: "description", detail: banner.description),
            APIRequest.Result(title: "is skipable", detail: banner.isSkipable.string),
            APIRequest.Result(title: "type", detail: banner.type.string),
            APIRequest.Result(title: "pack id", detail: banner.packId?.string ?? "null"),
            APIRequest.Result(title: "detail url", detail: banner.detailUrl),
            APIRequest.Result(title: "delay", detail: banner.delay.string)
        ]
    }
    
    private func nextBanner() {
        // Пример запроса рекомендованного данному устройству и приложению баннера
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.nextBanner { [weak self] (result) in
            guard let self = self else { return }
            self.handleBannerResult(result)
        }
    }
    
    private func handleBannerResult(_ result: Result<BannerAndDevice.Banner, Error>) {
        self.configureStopAnimating()
        
        switch result {
        case .success(let banner):
            self.configureBannerResult(banner)
            self.tableView.reloadData()
            print(banner)
        case .failure(let error):
            self.showAlert(error)
            print(error)
        }
    }
    
    private func deleteBanFromBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        // Пример запроса на снятие (удаление) пометки «нежелательный» с баннера
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.deleteBanFromBanner(bannerId: bannerId) { [weak self] (result) in
            guard let self = self else { return }
            self.handleBanBannerResult(result)
        }
    }
    
    private func handleBanBannerResult(_ result: Result<BanBanner, Error>) {
        self.configureStopAnimating()
        
        switch result {
        case .success(let banBanner):
            self.results = [APIRequest.Result(title: "result", detail: banBanner.result)]
            self.tableView.reloadData()
            print(banBanner)
            self.tableView.reloadData()
            print(banBanner)
        case .failure(let error):
            self.showAlert(error)
            print(error)
        }
    }
    
    private func banBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        // Пример запроса для отметки баннера как «нежелательный» для исключения из показа
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.banBanner(bannerId: bannerId) { [weak self] (result) in
            guard let self = self else { return }
            self.handleBanBannerResult(result)
        }
    }
    
    private func getBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        // Пример получения баннера (информацию о нём)
        let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
        apiClient.getBanner(bannerId: bannerId) { [weak self] (result) in
            guard let self = self else { return }
            self.handleBannerResult(result)
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
                    APIRequest.Result(title: "result", detail: ping.result),
                    APIRequest.Result(title: "time", detail: ping.time),
                    APIRequest.Result(title: "version", detail: ping.version),
                    APIRequest.Result(title: "hostname", detail: ping.hostname)
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
                self.results = channels.map { (channel) -> APIRequest.Result in
                    APIRequest.Result(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
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
                self.results = channels.map { (channel) -> APIRequest.Result in
                    APIRequest.Result(title: "id: \(channel.id)", detail: channel.attributes.name ?? "")
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
                self.results = broadcasts.map { (broadcast) -> APIRequest.Result in
                    APIRequest.Result(title: "id: \(broadcast.id)", detail: broadcast.attributes.title)
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
        self.changeColorTheme(.failure)
        if let error = error as? APIError,
            case let .jsonAPIError(statusCode, error: jsonAPIError) = error {
            if let error = jsonAPIError.errors.first {
                self.results = [
                    APIRequest.Result(title: "id", detail: error.id?.string ?? "-"),
                    APIRequest.Result(title: "status", detail: error.status),
                    APIRequest.Result(title: "code", detail: error.code),
                    APIRequest.Result(title: "title", detail: error.title),
                    APIRequest.Result(title: "detail", detail: error.detail ?? "nil")
                ]
                self.tableView.reloadData()
                let alert = UIAlertController(title: "Ошибка", message: "Неуспешный ответ состояния HTTP: \(statusCode)")
                self.present(alert, animated: true)
                return
            }
        }
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription)
        self.present(alert, animated: true)
    }
}
