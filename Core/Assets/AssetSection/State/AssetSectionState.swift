//
//  AssetSectionState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetSectionState: GraniteState {
    var securityType: SecurityType
    var toggleTitleIndex: Int = 0
    var context: WindowType
    
    public init(context: WindowType, _ securityType: SecurityType) {
        self.context = context
        self.securityType = securityType
        super.init()
    }
    
    required init() {
        self.context = .unassigned
        self.securityType = .unassigned
    }
}

public class AssetSectionCenter: GraniteCenter<AssetSectionState> {
    let stockRelay = StockRelay()
    let cryptoRelay = CryptoRelay()
    
    public override var behavior: GraniteEventBehavior {
        .broadcastable
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AssetSectionSelectedExpedition.Discovery(),
            AssetSectionNeedsRefreshExpedition.Discovery(),
            AssetSectionMoversStockExpedition.Discovery(),
            AssetSectionMoversCryptoExpedition.Discovery()
        ]
    }
    
    //Dependencies
    lazy var envDependency: EnvironmentDependency = {
        self.hosted.env
    }()
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    //
    
    var date: Date {
        movers.first?.date ?? .today
    }
    
    var movers: [Security] {
        guard let categories = envDependency.broadcasts.movers.get(state.securityType) else {
            return []
        }
        
        switch state.context {
        case .topVolume:
            return categories.topVolume
        case .winnersAndLosers:
            switch toggleTitleLabels[state.toggleTitleIndex] {
            case WindowType.winners(.unassigned).label:
                return categories.winners
            case WindowType.losers(.unassigned).label:
                return categories.losers
            default:
                return []
            }
        case .winners:
            return categories.winners
        case .losers:
            return categories.losers
        default:
            return []
        }
    }
    
    var toggleTitle: Bool {
        switch state.context {
        case .winnersAndLosers:
            return true
        default:
            return false
        }
    }
    
    var toggleTitleLabels: [String] {
        switch state.context {
        case .winnersAndLosers:
            return ["winners", "losers"]
        default:
            return []
        }
    }
}

