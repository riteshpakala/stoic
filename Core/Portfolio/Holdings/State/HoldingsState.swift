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
    case radio
    case standalone
    
    
}

public class HoldingsState: GraniteState {
    var addToPortfolio: Bool = false
    
    var context: WindowType
    
    
    var gridType: AssetGridType {
        switch context {
        case .floor:
            return .add
        case .portfolio(let type):
            switch type {
            case .preview, .expanded:
                return .standard
            default:
                return .add
            }
        case .strategy:
            return .radio
        default:
            return .standard
        }
    }
    
    public init(context: WindowType) {
        self.context = context
    }
    
    public required init() {
        self.context = .unassigned
//        self.assetAddState = .init(.init(.init(.portfolio(.unassigned))))
//        self.context = .portfolio(.unassigned)
//        self.floorStage = .none
//        self.type = .add
    }
}

public class HoldingsCenter: GraniteCenter<HoldingsState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            HoldingSelectedExpedition.Discovery(),
            HoldingSelectionsConfirmedExpedition.Discovery()
        ]
    }
}
