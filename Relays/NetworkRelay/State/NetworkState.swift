//
//  NetworkRelayState.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class NetworkState: GraniteState {
    let service: NetworkService = .init()
}

public class NetworkCenter: GraniteCenter<NetworkState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetExpedition.Discovery(),
            UpdateUserExpedition.Discovery(),
            ApplyUserExpedition.Discovery(),
            ApplyCodeExpedition.Discovery()
        ]
    }
}
