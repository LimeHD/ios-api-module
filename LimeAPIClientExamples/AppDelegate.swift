//
//  AppDelegate.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 12.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import AVFoundation
import LimeAPIClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.configureLimeAPIClient()
        self.configureLimeAudioSession()
        
        return true
    }
    
    private func configureLimeAPIClient() {
        // Пример конфигурирования клиента LimeAPIClient перед использованием
        // задается один раз до начала использования запросов
        let language = Locale.preferredLanguages.first ?? "ru-RU"
        let configuration = LACConfiguration(appId: APPLICATION_ID, apiKey: API_KEY.APPLICATION, language: language)
        LimeAPIClient.configuration = configuration
    }
    
    private func configureLimeAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 11.0, *) {
                try audioSession.setCategory(.playback, mode: .moviePlayback, policy: .longForm, options: [])
            } else if #available(iOS 10.0, *) {
                try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            } else {
                try audioSession.setCategory(.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Unable to set audio session category")
        }
    }
}

