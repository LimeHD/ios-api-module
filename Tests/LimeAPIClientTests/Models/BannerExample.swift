//
//  BannerExample.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 04.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

let BannerAndDeviceExample = """
{
    "banner": {
        "id": 5166,
        "image_url": "http://cdn.limehd.tv/images/banner_5166.jpg",
        "title": "Глобальная стройка в лесу!",
        "description": "<p><span style=\\"font-size: 14pt;\\">&laquo;Дом Брайана&raquo; на телеканале &laquo;Загородный&raquo;</span></p>",
        "is_skipable": true,
        "type": 20,
        "pack_id": 10,
        "detail_url": "",
        "delay": 3
    },
    "device": {
        "id": "123",
        "shown_banners": "{\\"68\\": 1588942169, \\"4689\\": 1588942167, \\"4716\\": 1588942167, \\"4717\\": 1588942165, \\"4718\\": 1588942165, \\"4719\\": 1588942166, \\"4733\\": 1588942166, \\"4757\\": 1588942166, \\"4761\\": 1588942168, \\"4811\\": 1588942168, \\"5123\\": 1591008103, \\"5127\\": 1591008101, \\"5128\\": 1591008096}",
        "skipped_banners": "[123, 1234, 4483, 4483222]",
        "created_at": "2020-05-08 07:35:56 UTC",
        "updated_at": "2020-05-08 07:35:56 UTC"
    }
}
"""

let BannerExample = """
{
    "id": 5166,
    "image_url": "http://cdn.limehd.tv/images/banner_5166.jpg",
    "title": "Глобальная стройка в лесу!",
    "description": "<p><span style=\\"font-size: 14pt;\\">&laquo;Дом Брайана&raquo; на телеканале &laquo;Загородный&raquo;</span></p>",
    "is_skipable": true,
    "type": 20,
    "pack_id": 10,
    "detail_url": "",
    "delay": 3
}
"""

let BanBannerExample = """
{
    "result": "unbanned"
}
"""
