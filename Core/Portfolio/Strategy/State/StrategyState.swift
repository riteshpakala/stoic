//
//  StrategyState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum StrategyStage: Equatable {
    case none
    case adding
}
public class StrategyState: GraniteState {
    var stage: StrategyStage = .none
}

public class StrategyCenter: GraniteCenter<StrategyState> {
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetStrategyExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(StrategyEvents.Get(), .dependant)
        ]
    }
    
    var strategies: [Strategy] {
        envDependency.user.portfolio?.strategies ?? []
    }
}
