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

public enum HoldingsStage {
    case updating
    case none
}

public class HoldingsState: GraniteState {
    var stage: HoldingsStage
    var securitiesToSync: [Security] = []
    var securitiesSynced: [String] = []
    var syncTimer: Timer? = nil
    
    var addToPortfolio: Bool = false
    
    var syncProgress: Double {
        Double(securitiesSynced.count)/Double(securitiesToSync.count)
    }
    
    var statusLabel: String {
        let count = securitiesToSync.count
        if count == .zero {
            return "up to date"
        } else {
            return "update \(count)"
        }
    }
    
    var context: WindowType
    
    public init(context: WindowType) {
        self.context = context
        self.stage = .none
    }
    
    public required init() {
        self.context = .unassigned
        self.stage = .none
//        self.assetAddState = .init(.init(.init(.portfolio(.unassigned))))
//        self.context = .portfolio(.unassigned)
//        self.floorStage = .none
//        self.type = .add
    }
}

public class HoldingsCenter: GraniteCenter<HoldingsState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetHoldingsExpedition.Discovery(),
            HoldingSelectedExpedition.Discovery(),
            HoldingSelectionsConfirmedExpedition.Discovery(),
            UpdateHoldingsExpedition.Discovery(),
            PushUpdateHoldingsExpedition.Discovery(),
            UpdateCompleteHoldingsExpedition.Discovery(),
            StockUpdatedHistoryHoldingsExpedition.Discovery(),
            CryptoUpdatedHistoryHoldingsExpedition.Discovery(),
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(HoldingsEvents.Get())
        ]
    }
}
