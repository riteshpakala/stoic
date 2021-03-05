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
    var sentimentLoadingProgress: Double = 0.0
}

public class TonalSetCenter: GraniteCenter<TonalSetState> {
    let tonalRelay: TonalRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    var tone: Tone {
        envDependency.tone
    }
    
    var stage: Tone.Set.State {
        tone.set.stage
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
    
    public override var links: [GraniteLink] {
        [
            .relay(\TonalState.sentimentProgress,
                   \TonalSetState.sentimentLoadingProgress, .dependant)
        ]
    }
}
