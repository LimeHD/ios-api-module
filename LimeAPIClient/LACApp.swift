//
//  LACApp.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct LACApp {
    public struct id {
        public static var custom = ""
        public static var bundle: String {
            Bundle.main.bundleIdentifier ?? ""
        }
    }
    
    static var version: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
}
