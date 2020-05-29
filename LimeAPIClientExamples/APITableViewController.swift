//
//  APITableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

struct Request {
    enum Name: String {
        case sessions
        case ping
        case channels
        case channelsByGroupId = "channels by group id"
        case broadcasts
    }
    
    struct Result {
        let title: String
        let detail: String
    }
    
    struct Parameter {
        let name: String
        let detail: String
    }
}

class APITableViewController: UITableViewController {
    struct API {
        let section: String
        let requestNames: [Request.Name]
    }
    
    var apiList = [API]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiList = [
            API(section: "sessions", requestNames: [.sessions]),
            API(section: "ping", requestNames: [.ping]),
            API(section: "channels", requestNames: [.channels, .channelsByGroupId]),
            API(section: "broadcasts", requestNames: [.broadcasts])
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
        return self.apiList[section].requestNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.apiList[indexPath.section].requestNames[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = self.tableView.cellForRow(at: indexPath),
            let cellText = cell.textLabel?.text,
            let requestName = Request.Name(rawValue: cellText)
        else { return }
        
        let controller = ResultTableViewController(requestName: requestName)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
