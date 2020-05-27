//
//  SubtitleTableViewCell.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 27.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "\(Self.self)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
