//
//  AssetGridState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetGridState: GraniteState {
    var count: Int = 0
    var securityData: [Security] = []
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AssetGridNewStockDataExpedition.Discovery(),
            MoversCryptoExpedition.Discovery(),
            MoversStockExpedition.Discovery()
        ]
    }
}
