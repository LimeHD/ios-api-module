//
//  BannerData.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct BannerData: Decodable {
    public let banner: Banner
    public let device: Device?
    
    public struct Banner: Decodable {
        public let id: Int
        public let imageUrl: String
        public let title: String
        public let description: String
        public let isSkipable: Bool
        public let type: Int
        public let packId: Int?
        public let detailUrl: String
        public let delay: Int
    }
    
    public struct Device: Decodable {
        public let id: String
        public let shownBanners: [String : Int]
        public let skippedBanners: [Int]
        public let createdAt: String
        public let updatedAt: String
    }
}
