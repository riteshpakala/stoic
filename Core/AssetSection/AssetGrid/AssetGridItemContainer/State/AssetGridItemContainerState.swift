//
//  AssetGridItemContainerState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetGridItemContainerState: GraniteState {
    var securityData: [Security] {
        payload?.object as? [Security] ?? []
    }
}

public class AssetGridItemContainerCenter: GraniteCenter<AssetGridItemContainerState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            MoversSecurityExpedition.Discovery()
        ]
    }
}
