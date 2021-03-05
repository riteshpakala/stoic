//
//  TonalCreateState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalCreateStage: ID, Hashable, Equatable {
    case none
    case find(GranitePayload)
    case set
    case tune
    case compile
}

public class TonalCreateState: GraniteState {
    
    var stage: TonalCreateStage = .none
    
    public init(_ stage: TonalCreateStage) {
        self.stage = stage
    }
    
    required init() {
        self.stage = .none
    }
}

public class TonalCreateCenter: GraniteCenter<TonalCreateState> {
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    public override var expeditions: [GraniteBaseExpedition] {
        []
    }
}
