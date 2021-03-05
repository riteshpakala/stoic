//
//  AssetSearchState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetSearchState: GraniteState {
    var securityData: [Security] = []
    let context: WindowType
    var floorStage: FloorStage
    var securityType: SecurityType = .stock
    
    public init(_ context: WindowType,
                floorStage: FloorStage? = nil) {
        self.context = context
        self.floorStage = floorStage ?? .none
    }
    
    public required init() {
        self.context = .unassigned
        self.floorStage = .none
    }
}

public class AssetSearchCenter: GraniteCenter<AssetSearchState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()

    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AssetSelectedExpedition.Discovery(),
            SearchAssetExpedition.Discovery()
        ]
    }
    
    var securities: [Security] {
        return (state.payload?.object as? [Security]) ?? []
//        switch state.context {
//        case .portfolio:
//            return envDependency2.holdingsPortfolio.assetAddState.searchState.securityGroup.get(state.securityType)
//        case .floor:
//            return envDependency2.holdingsFloor.assetAddState.searchState.securityGroup.get(state.securityType)
//        case .tonalCreate:
//            return envDependency2.searchTone.securityGroup.get(state.securityType)
//        case .search:
//            return envDependency2.search.securityGroup.get(state.securityType)
//        default:
//            return nil
//        }
    }
    
    var securityType: SecurityType {
        securities.first?.securityType ?? .unassigned
    }
}
