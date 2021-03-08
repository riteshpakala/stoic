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

public enum StrategyType: Equatable, Hashable {
    case expanded
    case preview
    case none
}

public enum StrategyStage: Equatable {
    case none
    case adding
    case choosingModel
    case syncing
    case predicting
    
    public var busy: Bool {
        self == .syncing || self == .predicting
    }
}
public class StrategyState: GraniteState {
    var stage: StrategyStage = .none
    
    var type: StrategyType
    
    var user: UserInfo? = nil
    
    var syncProgress: Double {
        Double(securitiesSynced.count)/Double(securitiesToSync.count)
    }
    
    var syncTimer: Timer? = nil
    var securitiesToSync: [Security] = []
    var securitiesSynced: [String] = []
    var securities: [Security] = []
    var strategy: Strategy = .init([], "", .today, .empty)
    
    var showOutdatedDisclaimer: Bool = false
    var showResetDisclaimer: Bool = false
    var showCloseDisclaimer: Bool {
        wantsToClose != nil
    }
    var showRemoveDisclaimer: Bool {
        wantsToRemove != nil
    }
    
    var wantsToClose: Strategy.Investments.Item? = nil
    var wantsToRemove: Strategy.Investments.Item? = nil
    
    var pickingModelForSecurity: Security? = nil
    
    var statusLabel: String {
        let count = securitiesToSync.count - securitiesSynced.count
        if count == .zero {
            return "predict"
        } else {
            return "sync \(count)"
        }
    }
    
    public init(_ type: StrategyType) {
        self.type = type
    }
    
    public required init() {
        self.type = .preview
    }
}

public class StrategyCenter: GraniteCenter<StrategyState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    @GraniteDependency
    var routerDependency: RouterDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    @GraniteDependency
    var strategyDependency: StrategyDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetStrategyExpedition.Discovery(),
            TestableStrategyExpedition.Discovery(),
            SyncPredictionsExpedition.Discovery(),
            SyncStrategyExpedition.Discovery(),
            ResetStrategyExpedition.Discovery(),
            PushSecurityStrategyExpedition.Discovery(),
            StockUpdatedHistoryExpedition.Discovery(),
            CryptoUpdatedHistoryExpedition.Discovery(),
            SyncCompleteStrategyExpedition.Discovery(),
            RemoveFromStrategyExpedition.Discovery(),
            CloseFromStrategyExpedition.Discovery(),
            PickModelForStrategyExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(StrategyEvents.Get())
        ]
    }
    
    var strategies: [Strategy] {
        [state.strategy]
    }
    
    var strategiesAreEmpty: Bool {
        envDependency.user.portfolio?.strategies.isEmpty == true ||
        envDependency.user.portfolio == nil
    }
}
