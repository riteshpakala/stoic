//
//  TonalFindState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalSetState: GraniteState {

}

public class TonalSetCenter: GraniteCenter<TonalSetState> {
    let tonalRelay: TonalRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    var tone: Tone {
        envDependency.tone
    }
    
    var ticker: String? {
        tone.find.ticker
    }
    
    var tonalRangeData: [TonalRange] {
        tone.range?.sorted(by: { $0.avgSimilarity > $1.avgSimilarity }) ?? []
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SetTheToneExpedition.Discovery(),
            TonalSentimentHistoryExpedition.Discovery()
        ]
    }
}
