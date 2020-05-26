//
//  LACConfiguration.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 22.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct LACConfiguration {
    let appId: String
    let apiKey: String
    let language: String
    var defaultChannelGroupId = ""
    
    public init(appId: String, apiKey: String, language: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.language = language
    }
}
