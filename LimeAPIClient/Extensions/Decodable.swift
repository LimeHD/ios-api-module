//
//  Decodable.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 23.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

extension Decodable {
    init(decoding data: Data, decoder: JSONDecoder = JSONDecoder()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
}
