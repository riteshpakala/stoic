//
//  HoldingsState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class HoldingsState: GraniteState {
}

public class HoldingsCenter: GraniteCenter<HoldingsState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            HoldingSelectedExpedition.Discovery()
        ]
    }
}
