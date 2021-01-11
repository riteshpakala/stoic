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
    var addToPortfolio: Bool = false
    var assetAddState: AssetAddState
    var context: WindowType
    var floorStage: FloorStage {
        didSet {
            assetAddState.searchState.state.floorStage = floorStage
        }
    }
    
    public init(_ searchState: SearchQuery, floorStage: FloorStage? = nil) {
        self.assetAddState = .init(searchState)
        self.context = self.assetAddState.searchState.state.context
        self.floorStage = floorStage ?? .none
    }
    
    public required init() {
        self.assetAddState = .init(.init(.init(.portfolio)))
        self.context = .portfolio
        self.floorStage = .none
    }
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
