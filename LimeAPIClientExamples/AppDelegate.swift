//
//  AppDelegate.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.configureLimeAPIClient()
        
        return true
    }
    
    private func configureLimeAPIClient() {
        // Пример конфигурирования клиента LimeAPIClient перед использованием
        // задается один раз до начала использования запросов
        let language = Locale.preferredLanguages.first ?? "ru-RU"
        let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
        LimeAPIClient.configuration = configuration
    }

}

