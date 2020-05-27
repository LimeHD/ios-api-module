//
//  AccessoryButton.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

class AccessoryButton: UIButton {
    var indexPath = IndexPath()

    convenience init(title: String, indexPath: IndexPath, tintColor: UIColor? = nil) {
        self.init(type: .system)
        self.indexPath = indexPath
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        self.cornerRadius = 5
        self.layer.borderWidth = 1.5
        self.layer.borderColor = self.tintColor.cgColor
        self.setTitle(title, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
        self.frame = CGRect(origin: CGPoint.zero, size: self.intrinsicContentSize)

    }

}
