//
//  UIView.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

// MARK: - Load View from Xib

extension UIView {
    private func getViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let bundleObjects = bundle.loadNibNamed(nibName, owner: self)
        let view = bundleObjects?.first as! UIView
        return view
    }
    
    func loadFromNib() {
        let view: UIView = getViewFromNib()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor)])
    }
}

// MARK: - IBInspectable cornerRadius

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}

// MARK: - Constraints

extension UIView {
    func constraint(_ attribute: NSLayoutConstraint.Attribute, equalTo view: Any, constant c: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: c)
    }
    
    @discardableResult
    func addConstraint(_ attribute: NSLayoutConstraint.Attribute, equalTo view: Any, constant c: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = self.constraint(attribute, equalTo: view, constant: c)
        constraint.isActive = true
        return constraint
    }
    
    func addCenterConstraints(equalTo view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
