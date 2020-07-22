//
//  SessionExample.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 03.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

struct SessionExample {
    static let correct = """
    {
        "session_id": "a6a718c37c13344da71cbc8edbf1ef00fb68620a",
        "current_time": "2020-06-03T14:13:09+03:00",
        "stream_endpoint": "https://api.iptv2021.com/v1/streams/${stream_id}/redirect",
        "archive_endpoint": "https://api.iptv2021.com/v1/streams/${stream_id}/archive_redirect",
        "default_channel_group_id": 1,
        "settings": {
            "is_ad_start": false,
            "is_ad_first_start": false,
            "is_ad_onl_start": true,
            "is_ad_arh_start": true,
            "is_ad_onl_out": false,
            "is_ad_arh_out": false,
            "is_ad_onl_full_out": true,
            "is_ad_arh_full_out": true,
            "is_ad_arh_pause_out": false,
            "ad_min_timeout": 30
        },
        "meta": {
            "policy_id": 3
        }
    }
    """
    
    static func failedEndpoint(_ endpoint: String) -> String {
        """
        {
            "session_id": "a6a718c37c13344da71cbc8edbf1ef00fb68620a",
            "current_time": "2020-06-03T14:13:09+03:00",
            "stream_endpoint": \"\(endpoint)\",
            "archive_endpoint": \"\(endpoint)\",
            "default_channel_group_id": 1,
            "settings": {
                "is_ad_start": false,
                "is_ad_first_start": false,
                "is_ad_onl_start": true,
                "is_ad_arh_start": true,
                "is_ad_onl_out": false,
                "is_ad_arh_out": false,
                "is_ad_onl_full_out": true,
                "is_ad_arh_full_out": true,
                "is_ad_arh_pause_out": false,
                "ad_min_timeout": 30
            },
            "meta": {
                "policy_id": 3
            }
        }
        """
    }
}

