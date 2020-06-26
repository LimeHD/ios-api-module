//
//  Value1Cell.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

class Value1Cell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "\(Self.self)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
