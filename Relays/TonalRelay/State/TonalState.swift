//
//  TonalState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalStage {
    case none
    case searching
    case predicting
    case compiling
}

public class TonalState: GraniteState {
    let modelThreads: Int = 1
    let dataChunks: Int = 3
    let service: TonalService = .init()
    var stage: TonalStage = .none
    var sentimentProgress: Double {
        service
        .soundAggregate
        .progress(
            threads: modelThreads,
            dateChunks: dataChunks)
    }
}

public class TonalCenter: GraniteCenter<TonalState> {
    
    public var progress: Double {
        state.sentimentProgress
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetSentimentExpedition.Discovery(),
            ProcessSentimentExpedition.Discovery(),
            TonalHistoryExpedition.Discovery(),
            TonalSoundsExpedition.Discovery()
        ]
    }
}
