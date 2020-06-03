//
//  DispatchQueue.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 03.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public protocol Dispatchable {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: Dispatchable {
    public func async(execute work: @escaping () -> Void) {
        self.async(group: nil, execute: work)
    }
}
