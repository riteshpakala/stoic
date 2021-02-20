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
    case syncing
}
public class StrategyState: GraniteState {
    var stage: StrategyStage = .none
    
    var user: UserInfo? = nil
    
    var syncProgress: Double {
        Double(securitiesSynced.count)/Double(securitiesToSync.count)
    }
    
    var syncTimer: Timer? = nil
    var securitiesToSync: [Security] = []
    var securitiesSynced: [String] = []
    var securities: [Security] = []
    
    var showResetDisclaimer: Bool = false
    var showCloseDisclaimer: Bool {
        wantsToClose != nil
    }
    var showRemoveDisclaimer: Bool {
        wantsToRemove != nil
    }
    
    var wantsToClose: Strategy.Investments.Item? = nil
    var wantsToRemove: Strategy.Investments.Item? = nil
    
    var statusLabel: String {
        let count = securitiesToSync.count - securitiesSynced.count
        if count == .zero {
            return "up to date"
        } else {
            return "sync \(count)"
        }
    }
}

public class StrategyCenter: GraniteCenter<StrategyState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetStrategyExpedition.Discovery(),
            SyncStrategyExpedition.Discovery(),
            ResetStrategyExpedition.Discovery(),
            PushSecurityStrategyExpedition.Discovery(),
            StockUpdatedHistoryExpedition.Discovery(),
            CryptoUpdatedHistoryExpedition.Discovery(),
            SyncCompleteStrategyExpedition.Discovery(),
            RemoveFromStrategyExpedition.Discovery(),
            CloseFromStrategyExpedition.Discovery(),
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
