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
    case updating
    case none
}

public enum TonalModelsType {
    case specified(Security)
    case general
}

public class TonalModelsState: GraniteState {
    var stage: TonalModelsStage
    var tones: [TonalModel]? = nil
    var tonesToSync: [String] = []
    var tonesSynced: [String] = []
    var securitiesToSync: [Security] = []
    var securitiesSynced: [String] = []
    var syncTimer: Timer? = nil
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
    
    //TODO: This progress should also include the initial quote
    //syncing phase.
    var syncProgress: Double {
        Double(tonesSynced.count)/Double(tonesToSync.count)
    }
    
    var statusLabel: String {
        let count = tonesToSync.count
        if count == .zero {
            return "up to date"
        } else {
            return "update \(count)"
        }
    }
}

public class TonalModelsCenter: GraniteCenter<TonalModelsState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    let tonalRelay: TonalRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalModelsEvents.Get(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetTonalModelsExpedition.Discovery(),
            TonalModelTappedExpedition.Discovery(),
            TonalModelAddExpedition.Discovery(),
            UpdateTonalModelsExpedition.Discovery(),
            PushTonalModelExpedition.Discovery(),
            TrainTonalModelExpedition.Discovery(),
            UpdateTonalModelCompleteExpedition.Discovery(),
            ThinkTonalModelExpedition.Discovery(),
            StockUpdatedHistoryTonalModelExpedition.Discovery(),
            CryptoUpdatedHistoryTonalModelExpedition.Discovery()
            
        ]
    }
}
