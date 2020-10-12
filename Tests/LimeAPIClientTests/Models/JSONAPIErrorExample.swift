//
//  JSONAPIErrorExample.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 21.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct JSONAPIErrorExample {
    static let base = """
    {
        "errors": [
            {
                "id": 64856824904380,
                "status": "401",
                "code": "unauthorized_error",
                "title": "UnauthorizedError"
            }
        ],
        "meta": {
            "request_id": "Request is not tracked"
        }
    }
    """
    static let standart = """
    {
        "errors": [
            {
                "code": "sequel/database_error",
                "status": "500",
                "title": "Sequel::DatabaseError",
                "detail": "detail hidden"
            }
        ],
        "meta": {
            "request_id": "Request is not tracked"
        }
    }
    """
    static let incorrectData = """
    {
        "errors": [
            {
                "code": "sequel/database_error",
                "status": true,
                "title": "Sequel::DatabaseError",
                "detail": "detail hidden"
            }
        ],
        "meta": {
            "request_id": "Request is not tracked"
        }
    }
    """
}
