//
//  ColorTheme.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit

struct ColorTheme {
    enum Mode {
        case success
        case failure
    }
    
    struct Background {
        static var header = UIColor.systemGreen
        static var view = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)
    }
    
    static func setMode(_ mode: Mode) {
        switch mode {
        case .success:
            Background.header = UIColor.systemGreen
            Background.view = #colorLiteral(red: 0.6509803922, green: 1, blue: 0.737254902, alpha: 1)
        case .failure:
            Background.header = UIColor.systemRed
            Background.view = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }
}
