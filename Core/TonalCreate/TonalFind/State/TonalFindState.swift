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
    var maxDays: Int = 30
    var minDays: Int = 4
    var dayRangevalue: Int = 0
    var quote: QuoteObject? = nil
}

public class TonalFindCenter: GraniteCenter<TonalFindState> {
    var tonalCreateDependency: TonalCreateDependency {
        return dependency.hosted as? TonalCreateDependency ?? .init(identifier: "none")
    }
    
    var daysSelected: Int {
        tonalCreateDependency.tone.range?.first?.dates.count ?? state.days
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            FindTheToneExpedition.Discovery(),
            TonalRangeChangedExpedition.Discovery(),
            ParseTonalRangeExpedition.Discovery(),
            SearchTheToneExpedition.Discovery(),
            SecuritySelectedForToneExpedition.Discovery()
        ]
    }
}
