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

public enum HoldingsType {
    case add
    case standalone
}

public class HoldingsState: GraniteState {
    var addToPortfolio: Bool = false
    var assetAddState: AssetAddState
    var context: WindowType
    var type: HoldingsType
    var floorStage: FloorStage {
        didSet {
            assetAddState.searchState.state.floorStage = floorStage
        }
    }
    
    public init(_ searchState: SearchQuery,
                floorStage: FloorStage? = nil,
                type: HoldingsType = .add) {
        self.assetAddState = .init(searchState)
        self.context = self.assetAddState.searchState.state.context
        self.floorStage = floorStage ?? .none
        self.type = type
    }
    
    public required init() {
        self.assetAddState = .init(.init(.init(.portfolio(.unassigned))))
        self.context = .portfolio(.unassigned)
        self.floorStage = .none
        self.type = .add
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
