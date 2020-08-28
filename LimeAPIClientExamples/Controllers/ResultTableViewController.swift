//
//  ResultTableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 27.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import AVFoundation
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
    
    private let request: APIRequest
    var parameters = [APIRequest.Parameter]()
    var results = [APIRequest.Result]()
    private var channels = [Channel]()
    private var channelsTemp = [Channel]()
    private var broadcasts = [Broadcast]()
    var broadcastChannelId: Int? = nil
    var broadcastStreamId: Int? = nil
    var broadcastTimeZone: TimeZone? = nil
    private var cachedImages = NSCache<NSString, UIImage>()
    private let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    private lazy var searchBar = UISearchBar()
    
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
        self.tableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
        LimeAPIClient.verbose()
        
        switch self.request {
        case
        .sessions,
        .findBanner,
        .nextBanner,
        .channels,
        .channelsByGroupId,
        .users:
            break
        case
        .deleteBanFromBanner,
        .banBanner,
        .getBanner:
            let detail = "Id баннера для модификации"
            self.parameters = [APIRequest.Parameter(name: "banner id", detail: detail, keyboardType: .numberPad)]
            return
        case .ping:
            let detail = "Запрос на проверку работоспособности сервиса. Устанавливает кеширующие заголовки"
            self.parameters = [APIRequest.Parameter(name: "key", detail: detail, keyboardType: .URL)]
            return
        case .broadcasts:
            self.parameters = [APIRequest.Parameter(name: "Канал")]
            return
        case .deepClicks:
            self.parameters = [
                APIRequest.Parameter(name: "query", detail: "Строка запроса", keyboardType: .default),
                APIRequest.Parameter(name: "path", detail: "Путь запроса", keyboardType: .default)]
            return
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
        self.tableView.register(Value1Cell.self)
    }
    
    private func configureAppearance() {
        self.navigationController?.navigationBar.tintColor = .black
        self.title = self.request.rawValue
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = ColorTheme.Background.view
        
        self.configureActivityIndicator()
        self.configureSearchBar()
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
    
    private func configureSearchBar() {
        switch self.request {
        case
        .channels,
        .channelsByGroupId:
            self.searchBar.placeholder = "Поиск канала"
            self.navigationItem.titleView = self.searchBar
            self.searchBar.delegate = self
        default:
            break
        }
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
        case .deepClicks:
            self.deepClicks()
        case .users:
            self.referral()
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
            if let keyboardType = self.parameters[indexPath.row].keyboardType {
                let cell = tableView.dequeueReusableCell(ParameterCell.self, for: indexPath)
                
                cell?.selectionStyle = .none
                cell?.parameterNameLabel.text = self.parameters[indexPath.row].name
                cell?.parameterValueTextField.keyboardType = keyboardType
                cell?.parameterDescriptionLabel.text = self.parameters[indexPath.row].detail
                cell?.backgroundColor = ColorTheme.Background.view
                
                return cell ?? UITableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(Value1Cell.self, for: indexPath)
                
                cell?.selectionStyle = .none
                cell?.textLabel?.text = self.parameters[indexPath.row].name
                cell?.detailTextLabel?.text = self.parameters[indexPath.row].detail
                cell?.backgroundColor = ColorTheme.Background.view
                cell?.accessoryType = .disclosureIndicator
                
                return cell ?? UITableViewCell()
            }
        case .results:
            let cell = tableView.dequeueReusableCell(SubtitleCell.self, for: indexPath)

            cell?.selectionStyle = .none
            cell?.textLabel?.text = self.results[indexPath.row].title
            cell?.detailTextLabel?.text = self.results[indexPath.row].detail
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.backgroundColor = ColorTheme.Background.view
            self.setImage(for: cell, at: indexPath)

            return cell ?? UITableViewCell()
        }
    }
    
    private func setImage(for cell: UITableViewCell?, at indexPath: IndexPath) {
        cell?.imageView?.image = nil
        guard let imageUrl = self.results[indexPath.row].imageUrl else { return }
        
        if let image = self.image(path: imageUrl) {
            cell?.imageView?.image = image
            return
        }

        self.apiClient.getImage(with: imageUrl) { [weak self] (result) in
            switch result {
            case let .success(image):
                let cell = self?.tableView.cellForRow(at: indexPath)
                let cellHeight = cell?.frame.size.height ?? 44
                let image = image.resize(cellHeight, cellHeight) ?? image
                self?.cachedImages.setObject(image, forKey: imageUrl as NSString)
                cell?.imageView?.contentMode = .scaleAspectFit
                cell?.imageView?.image = image
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case let .failure(error):
                print("Ошибка загрузки изображения. \(self?.results[indexPath.row].title ?? ""): \(self?.results[indexPath.row].detail ?? "") - \(imageUrl) \(error.localizedDescription)")
            }
        }
    }
    
    private func image(path: String) -> UIImage? {
        return self.cachedImages.object(forKey: path as NSString)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.request {
        case
        .channels,
        .channelsByGroupId:
            self.prepareOnlinePlaylistViewController(for: indexPath)
            return
        case .broadcasts:
            switch Section(indexPath.section) {
            case .parameters:
                self.navigationController?.pushViewController(ChannelsTableViewController(), animated: true)
            case .results:
                self.pushArchivePlaylistViewController(for: indexPath)
            }
            return
        default:
            break
        }
        
        guard
            let cell = tableView.cellForRow(at: indexPath),
            let path = cell.detailTextLabel?.text,
            let url = URL(string: path)
        else { return }
        UIApplication.shared.open(url: url)
    }
    
    private func prepareOnlinePlaylistViewController(for indexPath: IndexPath) {
        guard let streamId = self.channels[indexPath.row].attributes.streams.first?.id else {
            self.showAlert("Отсутсвует поток для воспроизведения")
            return
        }
        
        do {
            let playableKey = "playable"
            let asset = try LACStream.Online.urlAsset(for: streamId)
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.activityIndicator.startAnimating()
            asset.loadValuesAsynchronously(forKeys: [playableKey]) {
                DispatchQueue.main.async { [weak self] in
                    self?.configureStopAnimating()
                    let message: String
                    var error: NSError? = nil
                    let status = asset.statusOfValue(forKey: playableKey, error: &error)
                    switch status {
                    case .loaded:
                        print("Sucessfully loaded.")
                        let channelName = self?.channels[indexPath.row].attributes.name ?? "Канал без имени"
                        self?.pushOnlinePlaylistViewController(for: streamId, with: asset, channelName: channelName)
                        return
                    case .loading:
                        message = "The property \"isPlayable\" is not fully loaded."
                    case .failed:
                        message = error?.localizedDescription ?? "Unknown error"
                    case .cancelled:
                        message = "The attempt to load the property \"isPlayable\" was cancelled."
                    case .unknown:
                        message = "The property \"isPlayable\" status is unknown."
                    @unknown default:
                        fatalError("Unknown loading case for the property \"isPlayable\".")
                    }
                    self?.showAlert(message)
                }
            }
        } catch {
            self.showAlert(error)
        }
    }
    
    private func pushOnlinePlaylistViewController(for streamId: Int, with asset: AVURLAsset, channelName: String) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.activityIndicator.startAnimating()
        self.apiClient.getOnlinePlaylist(for: streamId) { [weak self] (result) in
            self?.configureStopAnimating()
            switch result {
            case let .success(playlist):
                let playlistController = PlaylistTableViewController(playlist: playlist, urlAsset: asset)
                playlistController.title = channelName
                self?.navigationController?.pushViewController(playlistController, animated: true)
            case let .failure(error):
                self?.showAlert(error)
            }
        }
    }
    
    private func pushArchivePlaylistViewController(for indexPath: IndexPath) {
        guard let streamId = self.broadcastStreamId else {
            self.configureStopAnimating()
            self.showAlert("На задан id потока")
            return
        }
        
        let broadcast = self.broadcasts[indexPath.row]
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.activityIndicator.startAnimating()
        self.apiClient.getArchivePlaylist(for: streamId, broadcast: broadcast) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            switch result {
            case let .success(playlist):
                let asset: AVURLAsset
                do {
                    asset = try LACStream.Archive.urlAsset(for: streamId, broadcast: broadcast)
                } catch {
                    self.showAlert(error)
                    return
                }
                let playlistController = PlaylistTableViewController(playlist: playlist, urlAsset: asset)
                playlistController.title = self.broadcasts[indexPath.row].attributes.title
                self.navigationController?.pushViewController(playlistController, animated: true)
            case let .failure(error):
                self.showAlert(error)
            }
        }
    }
    
    private func handleSessionError() {
        let error = LACStream.Error.sessionError.localizedDescription
        let alert = UIAlertController(title: "Ошибка", message: "\(error)\n\nЗапросить новую сессию?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let newSessionAction = UIAlertAction(title: "Новая сессия", style: .default) { [weak self] (_) in
            self?.apiClient.session { (result) in
                switch result {
                case .success(_):
                    let alert = UIAlertController(title: "Новая ссессия", message: "Данные получены")
                    self?.present(alert, animated: true)
                case let .failure(error):
                    self?.showAlert(error.localizedDescription)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(newSessionAction)
        alert.preferredAction = newSessionAction
        self.present(alert, animated: true)
    }
}

// MARK: - API Requests

extension ResultTableViewController {
    private func configureStopAnimating() {
        self.activityIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func session() {
        self.apiClient.session { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let session):
                self.results = APIRequest.Results.create(from: session)
                self.tableView.reloadData()
                print(session)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func findBanner() {
        self.apiClient.findBanner { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let bannerAndDevice):
                self.results = APIRequest.Results.create(from: bannerAndDevice)
                self.tableView.reloadData()
                print(bannerAndDevice)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func nextBanner() {
        self.apiClient.nextBanner { [weak self] (result) in
            self?.handleBannerResult(result)
        }
    }
    
    private func handleBannerResult(_ result: Result<BannerAndDevice.Banner, Error>) {
        self.configureStopAnimating()
        
        switch result {
        case .success(let banner):
            self.results = APIRequest.Results.create(from: banner)
            self.tableView.reloadData()
            print(banner)
        case .failure(let error):
            self.showAlert(error)
        }
    }
    
    private func deleteBanFromBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        
        self.apiClient.deleteBanFromBanner(bannerId: bannerId) { [weak self] (result) in
            self?.handleBanBannerResult(result)
        }
    }
    
    private func handleBanBannerResult(_ result: Result<BanBanner, Error>) {
        self.configureStopAnimating()
        
        switch result {
        case .success(let banBanner):
            self.results = [APIRequest.Result(title: "result", detail: banBanner.result)]
            self.tableView.reloadData()
            print(banBanner)
        case .failure(let error):
            self.showAlert(error)
        }
    }
    
    private func banBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        
        self.apiClient.banBanner(bannerId: bannerId) { [weak self] (result) in
            self?.handleBanBannerResult(result)
        }
    }
    
    private func getBanner() {
        let bannerIdIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let bannerIdCell = self.tableView.cellForRow(at: bannerIdIndexPath) as? ParameterCell else { return }
        
        let bannerId = bannerIdCell.parameterValueTextField.text?.int ?? 0
        
        self.apiClient.getBanner(bannerId: bannerId) { [weak self] (result) in
            self?.handleBannerResult(result)
        }
    }
    
    private func ping() {
        let keyIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        guard let keyCell = self.tableView.cellForRow(at: keyIndexPath) as? ParameterCell else { return }
    
        let key = keyCell.parameterValueTextField.text ?? ""
        
        self.apiClient.ping(key: key) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let ping):
                self.results = APIRequest.Results.create(from: ping)
                self.tableView.reloadData()
                print(ping)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func requestChannels() {
        self.apiClient.requestChannels { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let channels):
                self.handleChannelsResult(channels)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func handleChannelsResult(_ channels: [Channel]) {
        self.results = APIRequest.Results.create(from: channels)
        self.channels = channels
        self.tableView.reloadData()
        print(channels)
    }
    
    private func requestChannelsByGroupId() {
        self.apiClient.requestChannelsByGroupId { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let channels):
                self.handleChannelsResult(channels)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func requestBroadcasts() {
        guard let channelId = self.broadcastChannelId else {
            self.configureStopAnimating()
            self.showAlert("Выберите канал")
            return
        }
        
        guard let timeZone = self.broadcastTimeZone else {
            self.configureStopAnimating()
            self.showAlert("Не указан часовой пояс")
            return
        }
        
        let startDate = Date().addingTimeInterval(-3.days)
        let dateInterval = LACDateInterval(start: startDate, duration: 7.days, timeZone: timeZone)
        self.apiClient.requestBroadcasts(channelId: channelId, dateInterval: dateInterval) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let broadcasts):
                self.results = broadcasts.map { (broadcast) -> APIRequest.Result in
                    APIRequest.Result(title: "id: \(broadcast.duration ?? 0)", detail: broadcast.attributes.title)
                }
                self.broadcasts = broadcasts
                self.tableView.reloadData()
                print(broadcasts)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func deepClicks() {
        let queryIndexPath = IndexPath(row: 0, section: Section.parameters.rawValue)
        let queryCell = self.tableView.cellForRow(at: queryIndexPath) as? ParameterCell
        let query = queryCell?.parameterValueTextField.text ?? ""
        
        let pathIndexPath = IndexPath(row: 1, section: Section.parameters.rawValue)
        let pathCell = self.tableView.cellForRow(at: pathIndexPath) as? ParameterCell
        let path = pathCell?.parameterValueTextField.text ?? ""
        
        self.apiClient.deepClicks(query: query, path: path) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let response):
                self.results = [APIRequest.Result(title: "Ответ сервера", detail: response)]
                self.tableView.reloadData()
                print(response)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func referral() {
        self.apiClient.referral(xToken: X_TOKEN) { [weak self] (result) in
            guard let self = self else { return }
            self.configureStopAnimating()
            
            switch result {
            case .success(let referral):
                self.results = referral.apiRequestResult
                self.tableView.reloadData()
                print(referral)
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func showAlert(_ error: Error) {
        print(error)
        
        if let error = error as? APIError,
            case .unknownChannelsGroupId = error {
            self.handleSessionError()
            return
        }
        if let error = error as? LACStream.Error,
            case .sessionError = error {
            self.handleSessionError()
            return
        }
        self.changeColorTheme(.failure)
        if let error = error as? APIError,
            case let .jsonAPIError(statusCode, error: jsonAPIError) = error {
            if let error = jsonAPIError.errors.first {
                self.results = APIRequest.Results.create(from: error)
                self.tableView.reloadData()
                self.showAlert("Неуспешный ответ состояния HTTP: \(statusCode)")
                return
            }
        }
        self.showAlert(error.localizedDescription)
    }
    
    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error)
        self.present(alert, animated: true)
    }
}

extension ResultTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.channels = self.channelsTemp
        } else {
            if self.channelsTemp.isEmpty {
                self.channelsTemp = self.channels
            }
            self.channels = self.channelsTemp.filter {
                $0.id.contains(searchText) || ($0.attributes.name?.contains(searchText) ?? false)
            }
        }
        self.results = APIRequest.Results.create(from: self.channels)
        self.tableView.reloadData()
    }
}
