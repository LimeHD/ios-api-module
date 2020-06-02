//
//  URL.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 25.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension URL {
    func addingQueryItems(parameters: [String : String], resolvingAgainstBaseURL resolve: Bool) -> URL? {
        guard !parameters.isEmpty else { return nil }
        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: resolve) {
            urlComponents.addQueryItems(parameters: parameters)
            return urlComponents.url
        }
        return nil
    }
}
