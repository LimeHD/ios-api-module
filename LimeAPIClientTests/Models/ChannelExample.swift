//
//  ChannelExample.swift
//  LimeAPIClientTests
//
//  Created by Лайм HD on 03.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

let ChannelExample = """
{
    "data": [
        {
            "id": "10530",
            "type": "channel",
            "attributes": {
                "name": "No channel title 10530",
                "image_url": null,
                "streams": []
            }
        },
        {
            "id": "105",
            "type": "channel",
            "attributes": {
                "name": "Первый канал",
                "image_url": "http://cdn.limehd.tv/images/playlist_1channel.png",
                "description": "Channel One (Russian: Первый канал, tr. Perviy kanal, literally First Channel) is the first television channel to broadcast in the Russian Federation. It has its headquarters in the Technical Center \\"Ostankino\\" near the Ostankino Tower, Moscow.First among Russia's country-wide channels, Channel One has more than 250 million viewers worldwide. From 1995 to 2002 the channel was known as Public Russian Television (Russian: Общественное Российское Телевидение, tr. Obshchestvennoye Rossiyskoye Televideniye, ORT) or Russian Public Television",
                "streams": [
                    {
                        "id": 57,
                        "time_zone": "UTC+03:00",
                        "archive_hours": 0,
                        "content_type": "application/vnd.apple.mpegurl"
                    }
                ]
            }
        }
    ]
}
"""
