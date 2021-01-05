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
    let modelThreads: Int = 6
    let dataChunks: Int = 3
    let dataScale: Int = 360
    let service: TonalService = .init()
    var stage: TonalStage = .none 
    var sentimentProgress: Double {
        service
        .soundAggregate
        .progress(
            threads: modelThreads,
            dateChunks: dataChunks)
    }
    
    lazy var operationQueue: OperationQueue = {
        var queue: OperationQueue = .init()
        queue.maxConcurrentOperationCount = 4
        queue.name = "tonal.relay.predict.op"
        queue.qualityOfService = .utility
        return queue
    }()
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
