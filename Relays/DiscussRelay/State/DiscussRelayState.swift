//
//  ClockState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class Conversation {
    var messages: [DiscussMessage] = []
    var channel: DiscussServiceModels.IRCChannel
    var users: [DiscussServiceModels.User] = []
    
    public init(_ channel: DiscussServiceModels.IRCChannel) {
        self.channel = channel
    }
}

public class DiscussRelayState: GraniteState {
    var service: DiscussService = .init()
    var channel: DiscussServiceModels.IRCChannel? = nil
    var listener: GraniteConnection? = nil
    var conversations: [Conversation] = []
    var user: User? = nil
}

public class DiscussRelayCenter: GraniteCenter<DiscussRelayState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            DiscussSendExpedition.Discovery(),
            DiscussReceiveExpedition.Discovery(),
            DiscussClientHandlingExpedition.Discovery(),
            DiscussClientReconnectExpedition.Discovery(),
            DiscussClientRegisteredExpedition.Discovery(),
            DiscussClientListenerExpedition.Discovery(),
            DiscussChannelJoinExpedition.Discovery(),
            DiscussUserListExpedition.Discovery(),
            DiscussUserJoinExpedition.Discovery(),
            DiscussUserLeftExpedition.Discovery(),
            DiscussUserQuitExpedition.Discovery()
        ]
    }
}
