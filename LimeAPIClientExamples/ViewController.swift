//
//  ViewController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Пример запроса на получение списка каналов для теста
        let apiClient = LimeAPIClient(baseUrl: BASE_URL)
        apiClient.requestChannels { (result) in
            switch result {
            case .success(let channels):
                print(channels)
            case .failure(let error):
                print(error)
            }
        }
    }

}

