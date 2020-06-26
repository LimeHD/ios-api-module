//
//  UINavigationController.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UINavigationController {
    var previousViewController: UIViewController? {
        let count = self.viewControllers.count
        guard count > 1 else { return nil }
        return self.viewControllers[count - 2]
    }
}
