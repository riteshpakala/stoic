//
//  TonalModelsState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalModelsStage {
    case fetching
    case none
}

public enum TonalModelsType {
    case specified(Security)
    case general
}

public class TonalModelsState: GraniteState {
    var stage: TonalModelsStage
    var tones: [TonalModel]? = nil
    var type: TonalModelsType
    
    var security: Security? {
        self.payload?.object as? Security
    }
    
    public init(_ stage: TonalModelsStage) {
        self.stage = stage
        self.type = .general
    }
    
    public required init() {
        self.stage = .none
        self.type = .general
    }
}

public class TonalModelsCenter: GraniteCenter<TonalModelsState> {
    var createText: String {
        switch state.type {
        case .specified(let security):
            return "\(security.display) model"
        case .general:
            return "create"
        }
    }
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalModelsEvents.Get(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetTonalModelsExpedition.Discovery(),
            TonalModelTappedExpedition.Discovery()
        ]
    }
}
