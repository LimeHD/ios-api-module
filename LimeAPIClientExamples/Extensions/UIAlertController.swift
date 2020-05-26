//
//  UIAlertController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String?, message: String?, defaultActionTitle: String = "Ок",
    defaultAction: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: defaultActionTitle, style: .default, handler: defaultAction)
        self.addAction(action)
        self.preferredAction = action
    }
}
