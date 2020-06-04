//
//  UIApplication.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UIApplication {
    @discardableResult
    func open(
        url: URL,
        checkCanOpenURL: Bool = true,
        options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) -> Bool {
        if checkCanOpenURL {
            if !self.canOpenURL(url) {
                return false
            }
        }
        
        if #available(iOS 10, *) {
            self.open(url, options: options, completionHandler: completion)
        } else {
            self.openURL(url)
        }
        
        return true
    }
}
