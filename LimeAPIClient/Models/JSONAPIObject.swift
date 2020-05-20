//
//  JSONAPIObject.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct JSONAPIObject<T: Decodable, U: Decodable>: Decodable {
    let data: T
    let meta: U?
}
