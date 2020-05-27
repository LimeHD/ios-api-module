//
//  UINavigationItem.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 27.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func removeBackBarButtonItemTitle() {
        self.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
