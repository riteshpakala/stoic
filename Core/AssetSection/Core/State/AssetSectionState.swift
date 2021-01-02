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
    var securityData: [Security] = []
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
    
    private var moverExpeditions: GraniteBaseExpedition {
        if state.securityType == .stock {
            return MoversStockExpedition.Discovery()
        } else {
            return MoversCryptoExpedition.Discovery()
        }
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            moverExpeditions
        ]
    }
}
