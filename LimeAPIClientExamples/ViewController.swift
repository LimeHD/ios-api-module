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
        LimeAPIClient.getTestChannels(url: TEST_CHANNELS_URL)
    }

}

