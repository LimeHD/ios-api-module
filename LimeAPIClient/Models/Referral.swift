//
//  Referral.swift
//  LimeAPIClient
//
//  Created by Лайм HD on 26.08.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import Foundation

public struct Referral: Decodable, Equatable {
    public let currentTime: String
    public let shareUrl: String
    public let userReferralUrl: String
    public let userReferralUrlExpiredAt: String
    public let referralsCount: Int
}
