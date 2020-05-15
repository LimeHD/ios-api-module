//
//  JSONParser.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 15.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

class JSONParser {
    let decoder: JSONDecoder
    
    init(_ decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func decode<T: Decodable>(_ type: T.Type, _ data: Data) -> Result<T, Error> {
        do {
            let result = try self.decoder.decode(T.self, from: data)
            return Result.success(result)
        } catch {
            return Result.failure(error)
        }
    }
}
