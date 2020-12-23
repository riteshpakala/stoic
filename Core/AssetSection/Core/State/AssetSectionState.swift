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
    var title: String
    
    public init(title: String) {
        self.title = title
        super.init()
    }
    
    required init() {
        self.title = ""
    }
}

public class AssetSectionCenter: GraniteCenter<AssetSectionState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            MoversCryptoExpedition.Discovery(),
            MoversStockExpedition.Discovery()
        ]
    }
}
