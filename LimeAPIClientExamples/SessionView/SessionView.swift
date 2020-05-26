//
//  SessionView.swift
//  LimeAPIClientExamples
//
//  Created by Лайм HD on 26.05.2020.
//  Copyright © 2020 Лайм HD. All rights reserved.
//

import UIKit
import LimeAPIClient

@IBDesignable
class SessionView: UIView {
    @IBOutlet private weak var sessionIdLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var streamEndpointLabel: UILabel!
    @IBOutlet private weak var groupIdLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
        self.reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
        self.reset()
    }
    
    func reset() {
        self.sessionIdLabel.text = "-"
        self.currentTimeLabel.text = "-"
        self.streamEndpointLabel.text = "-"
        self.groupIdLabel.text = "-"
    }
    
    func set(_ session: Session) {
        self.sessionIdLabel.text = session.sessionId
        self.currentTimeLabel.text = session.currentTime
        self.streamEndpointLabel.text = session.streamEndpoint
        self.groupIdLabel.text = session.defaultChannelGroupId.string
    }
}
