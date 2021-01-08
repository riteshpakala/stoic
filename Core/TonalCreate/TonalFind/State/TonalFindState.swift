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
    var maxDays: Int = Tone.Constraints.maxDays
    var minDays: Int = Tone.Constraints.minDays
    var dayRangevalue: Int = 0
    var quote: QuoteObject? = nil
    
    public init(_ days: Int) {
        self.days = days
    }
    
    required init() {}
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
        envDependency.tone.find.daysSelected
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
