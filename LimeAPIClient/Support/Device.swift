//
//  Device.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

struct Device {
    static var name: String {
        let name = UIDevice.current.name.filteringEmoji
        let percentEncodingName = name.addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed) ?? ""
        return percentEncodingName
    }
    
    static var id: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var language: String {
        Locale.preferredLanguages.first ?? "ru-RU"
    }
}
