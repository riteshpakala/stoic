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
    var days: Int = 5
    var maxDays: Int = 30
    var minDays: Int = 4
    var dayRangevalue: Int = 0
    var quote: QuoteObject? = nil
}

public class TonalFindCenter: GraniteCenter<TonalFindState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    var ticker: String {
        envDependency.tone.find.ticker ?? ""
    }
    
    var findState: Tone.Find.State {
        envDependency.tone.find.state
    }
    
    var daysSelected: Int {
        /*tonalCreateDependency.tone.range?.first?.dates.count ?? */state.days
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            FindTheToneExpedition.Discovery(),
            StockHistoryExpedition.Discovery(),
            TonalRangeChangedExpedition.Discovery(),
            ParseTonalRangeExpedition.Discovery(),
        ]
    }
}
