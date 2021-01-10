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
    var windowType: WindowType
    
    public init(windowType: WindowType, _ securityType: SecurityType) {
        self.windowType = windowType
        self.securityType = securityType
        super.init()
    }
    
    required init() {
        self.windowType = .unassigned
        self.securityType = .unassigned
    }
}

public class AssetSectionCenter: GraniteCenter<AssetSectionState> {
    //Dependencies
    lazy var envDependency: EnvironmentDependency = {
        self.hosted.env
    }()
    //
    
    var movers: [Security] {
        guard let categories = envDependency.broadcasts.movers.get(state.securityType) else {
            return []
        }
        print("{TEST} --- \(categories.topVolume.count)")
        switch state.windowType {
        case .topVolume:
            return categories.topVolume
        case .winners:
            return categories.winners
        case .losers:
            return categories.losers
        default:
            return []
        }
    }
}
