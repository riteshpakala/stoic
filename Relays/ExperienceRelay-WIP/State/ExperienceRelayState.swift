//
//  ExperienceState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class ExperienceRelayState: GraniteState {
}

public class ExperienceRelayCenter: GraniteCenter<ExperienceRelayState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            ExperienceForwardExpedition.Discovery(),
        ]
    }
}
