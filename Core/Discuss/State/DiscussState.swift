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
    var users: [User] = []
    var currentMessage: String = ""
    var currentChannel: String = "general"
    var showMembers: Bool = false
}

public class DiscussCenter: GraniteCenter<DiscussState> {
    @GraniteInject
    var discussDependency: DiscussDependency
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            DiscussLoadExpedition.Discovery(),
            DiscussSendMessageExpedition.Discovery(),
            DiscussMessagesExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(DiscussEvents.Load())
        ]
    }
    
    var user: UserInfo {
        envDependency2.user.info
    }
    
    public var environmentSafeArea: CGFloat {
        if let height = envDependency2.envSettings.lf?.data.height {
            return abs(EnvironmentConfig.iPhoneScreenHeight - height)
        } else {
            return 0
        }
    }
}
