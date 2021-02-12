//
//  DiscussState.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class DiscussState: GraniteState {
    var messages: [DiscussMessage] = []
    var currentMessage: String = ""
    var currentChannel: String = "general"
}

public class DiscussCenter: GraniteCenter<DiscussState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            DiscussLoadExpedition.Discovery(),
            DiscussSendMessageExpedition.Discovery(),
            DiscussMessagesExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
//            .onAppear(DiscussEvents.Load(), .dependant)
        ]
    }
    
    var user: UserInfo {
        envDependency.user.info
    }
    
    public var environmentSafeArea: CGFloat {
        if let height = envDependency.envSettings.lf?.data.height {
            return abs(EnvironmentConfig.iPhoneScreenHeight - height)
        } else {
            return 0
        }
    }
}
