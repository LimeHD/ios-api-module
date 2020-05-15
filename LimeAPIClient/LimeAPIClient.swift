//
//  LimeAPIClient.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 13.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

let module = NSStringFromClass(LimeAPIClient.self).components(separatedBy:".")[0]

public final class LimeAPIClient {
    static public func getTestChannels(url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url, endPoint: .testChannels)
        HttpClient(URLSession.shared).getJSON(with: request) { (result) in
            
        }
    }
}
