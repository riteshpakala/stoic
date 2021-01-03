//
//  TonalFindState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalFindState: GraniteState {
    var securityData: [Security] = []
}

public class TonalFindCenter: GraniteCenter<TonalFindState> {
    
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SearchTheToneExpedition.Discovery(),
            SecuritySelectedForToneExpedition.Discovery()
        ]
    }
}
