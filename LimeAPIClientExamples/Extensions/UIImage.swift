//
//  UIImage.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 17.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(_ width: CGFloat, _ height: CGFloat) -> UIImage? {
        let widthRatio  = width / self.size.width
        let heightRatio = height / self.size.height
        let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
