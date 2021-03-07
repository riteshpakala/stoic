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
    
    public init(_ days: Int) {
        self.days = days
    }
    
    required init() {}
}

public class TonalFindCenter: GraniteCenter<TonalFindState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalFindEvents.Find()),
        ]
    }
    
    @GraniteDependency
    var routerDependency: RouterDependency
    
    @GraniteDependency
    var toneDependency: ToneDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    var ticker: String {
        toneDependency.tone.find.ticker ?? ""
    }
    
    var findState: Tone.Find.State {
        toneDependency.tone.find.state
    }
    
    var daysSelected: Int {
        toneDependency.tone.find.daysSelected
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            ToneSelectedExpedition.Discovery(),
            FindTheToneExpedition.Discovery(),
            StockHistoryExpedition.Discovery(),
            CryptoHistoryExpedition.Discovery(),
            TonalRangeChangedExpedition.Discovery(),
            ParseTonalRangeExpedition.Discovery(),
        ]
    }
}
