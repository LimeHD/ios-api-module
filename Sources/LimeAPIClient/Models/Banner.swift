//
//  Banner.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 01.06.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct BannerAndDevice: Decodable, Equatable {
    public let banner: Banner
    public let device: Device?
    
    public struct Banner: Decodable, Equatable {
        public let id: Int
        public let imageUrl: String
        public let title: String
        public let description: String
        public let isSkipable: Bool
        public let type: Int
        public let packId: Int?
        public let detailUrl: String
        public let delay: Int
        public let buttonText: String
    }
    
    public struct Device: Decodable, Equatable {
        public let id: String
        public let shownBanners: String
        public let skippedBanners: String
        public let createdAt: String
        public let updatedAt: String
    }
}

public struct BanBanner: Decodable, Equatable {
    public let result: String
}
