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

public class DiscussRelayState: GraniteState {
    var service: DiscussService = .init()
    var channel: DiscussServiceModels.IRCChannel? = nil
    var listener: GraniteConnection? = nil
}

public class DiscussRelayCenter: GraniteCenter<DiscussRelayState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            DiscussSendExpedition.Discovery(),
            DiscussReceiveExpedition.Discovery(),
            DiscussClientHandlingExpedition.Discovery(),
            DiscussClientRegisteredExpedition.Discovery(),
            DiscussClientListenerExpedition.Discovery(),
            DiscussChannelJoinExpedition.Discovery()
        ]
    }
}
