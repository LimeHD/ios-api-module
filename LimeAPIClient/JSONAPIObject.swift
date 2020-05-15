//
//  JSONAPIObject.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct JSONAPIObject<T: Decodable>: Decodable {
    let data: [JSONAPIData<T>]
}

struct JSONAPIData<T: Decodable>: Decodable {
    let id: String
    let type: String
    let attributes: T
}
