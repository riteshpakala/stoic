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
    var days: Int = 7
    var quote: QuoteObject? = nil
}

public class TonalFindCenter: GraniteCenter<TonalFindState> {
    var tonalCreateDependency: TonalCreateDependency {
        return dependency.hosted as? TonalCreateDependency ?? .init(identifier: "none")
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            FindTheToneExpedition.Discovery(),
            ParseTonalRangeExpedition.Discovery(),
            SearchTheToneExpedition.Discovery(),
            SecuritySelectedForToneExpedition.Discovery()
        ]
    }
}
