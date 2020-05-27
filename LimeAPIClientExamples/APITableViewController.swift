//
//  APITableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

enum Request: String {
    case sessions
    case ping
    case channels
    case channelsByGroupId = "channels by group id"
    case broadcasts
}

class APITableViewController: UITableViewController {
    struct API {
        let section: String
        let requests: [Request]
    }
    
    var apiList = [API]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiList = [
            API(section: "sessions", requests: [.sessions]),
            API(section: "ping", requests: [.ping]),
            API(section: "channels", requests: [.channels, .channelsByGroupId]),
            API(section: "broadcasts", requests: [.broadcasts])
        ]
        
        self.tableView.removeExtraEmptyCells()
        self.navigationItem.removeBackBarButtonItemTitle()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.apiList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.apiList[section].section
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = self.tableView.cellForRow(at: indexPath),
            let cellText = cell.textLabel?.text,
            let request = Request(rawValue: cellText)
        else { return }
        
        let controller = ResultTableViewController(request: request)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
