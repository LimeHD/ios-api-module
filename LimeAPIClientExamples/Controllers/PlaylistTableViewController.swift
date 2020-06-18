//
//  PlaylistTableViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 18.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import AVKit
import LimeAPIClient

class PlaylistTableViewController: UITableViewController {
    private let playlist: [String]
    private let streamId: Int
    
    init(playlist: String, streamId: Int) {
        self.playlist = playlist.components(separatedBy: .newlines).dropLast()
        self.streamId = streamId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureAppearance()
        self.tableView.register(UITableViewCell.self)
    }
    
    private func configureAppearance() {
        self.navigationController?.navigationBar.tintColor = .black
        self.tableView.removeExtraEmptyCells()
        self.view.backgroundColor = ColorTheme.Background.view
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlist.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        cell?.textLabel?.text = self.playlist[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.backgroundColor = ColorTheme.Background.view
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath),
            cell.textLabel?.text?.contains("#EXT-X-STREAM-INF") ?? false
        else { return }
        
        let asset: AVURLAsset
        do {
            asset = try LACStream.online(streamId: streamId)
        } catch {
            let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription)
            self.present(alert, animated: true)
            return
        }
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
