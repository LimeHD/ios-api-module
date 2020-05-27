//
//  UITableView.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 27.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

extension UITableView {
    func removeExtraEmptyCells() {
        self.tableFooterView = UIView()
    }
}

// MARK: - TableViewCells Handlers

extension UITableView {
    func register(_ cellClass: AnyClass) {
        self.register(cellClass, forCellReuseIdentifier: "\(cellClass.self)")
    }
    
    func dequeueReusableCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: "\(cellClass.self)", for: indexPath) as? T
    }
}
