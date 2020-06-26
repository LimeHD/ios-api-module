//
//  ChannelsTableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

class ChannelsTableViewController: UITableViewController {
    private var channels = [Channel]()
    private var channelsTemp = [Channel]()
    private let apiClient = LimeAPIClient(baseUrl: BASE_URL.TEST)
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    private lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureAppearance()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(SubtitleCell.self)
        self.requestChannels()
    }
    
    private func configureAppearance() {
        self.title = "Выбор канала"
        self.navigationController?.navigationBar.tintColor = .black
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = ColorTheme.Background.view
        self.configureActivityIndicator()
        self.configureSearchBar()
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.addCenterConstraints(equalTo: self.view)
    }
    
    private func configureSearchBar() {
        self.searchBar.placeholder = "Поиск канала"
        self.navigationItem.titleView = self.searchBar
        self.searchBar.delegate = self
    }
    
    private func requestChannels() {
        self.activityIndicator.startAnimating()
        
        self.apiClient.requestChannels { [weak self] (result) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let channels):
                self.channels = channels
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(error)
            }
        }
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription)
        self.present(alert, animated: true)
        print(error)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SubtitleCell.self, for: indexPath)
        let channel = self.channels[indexPath.row]
        cell?.textLabel?.text = "\(channel.id): \(channel.attributes.name ?? "(пустое значение)")"
        var archives = channel.attributes.streams.map { $0.archiveHours.string }.joined(separator: ", ")
        if !archives.isEmpty {
            archives = ", Архив, час.: \(archives)"
        }
        cell?.detailTextLabel?.text = "Потоки: \(channel.attributes.streams.count)\(archives)"
        cell?.backgroundColor = ColorTheme.Background.view
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let resultController = self.navigationController?.previousViewController as? ResultTableViewController else {
            return
        }
        let channel = self.channels[indexPath.row]
        let stream = channel.attributes.streams.first
        resultController.broadcastChannelId = channel.id.int
        resultController.broadcastStreamId = stream?.id
        if let utcStringTimeZone = stream?.timeZone {
            resultController.broadcastTimeZone = TimeZone(utcString: utcStringTimeZone)
        }
        resultController.parameters[0] = APIRequest.Parameter(name: "Канал", detail: channel.attributes.name ?? "(пустое значение)")
        resultController.results = []
        resultController.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}


extension ChannelsTableViewController: UISearchBarDelegate {
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
        self.tableView.reloadData()
    }
}
