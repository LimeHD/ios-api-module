//
//  Referral.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.08.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import LimeAPIClient

extension Referral {
    var apiRequestResult: [APIRequest.Result] {
    [
        APIRequest.Result(title: "current time", detail: self.currentTime),
        APIRequest.Result(title: "share url", detail: self.shareUrl),
        APIRequest.Result(title: "user referral url", detail: self.userReferralUrl),
        APIRequest.Result(title: "user referral url expired at", detail: self.userReferralUrlExpiredAt)
    ]
}
