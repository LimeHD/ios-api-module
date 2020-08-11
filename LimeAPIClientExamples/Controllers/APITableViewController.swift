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
        let section: String
        let requests: [APIRequest]
    }
    
    var apiList = [API]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiList = [
            API(section: "sessions", requests: [.sessions]),
            API(section: "ping", requests: [.ping]),
            API(section: "banners", requests: [
                .findBanner, .nextBanner, .deleteBanFromBanner, .banBanner, .getBanner
            ]),
            API(section: "channels", requests: [
                .channels, .channelsByGroupId
            ]),
            API(section: "broadcasts", requests: [.broadcasts]),
            API(section: "deep clicks", requests: [.deepClicks])
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
        cell.detailTextLabel?.text = self.apiList[indexPath.section].requests[indexPath.row].detail
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = self.tableView.cellForRow(at: indexPath),
            let cellText = cell.textLabel?.text,
            let request = APIRequest(rawValue: cellText)
        else { return }
        
        let controller = ResultTableViewController(request: request)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
