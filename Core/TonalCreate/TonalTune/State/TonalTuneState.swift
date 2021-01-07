//
//  TonalTuneState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalTuneState: GraniteState {
    var sentimentLoadingProgress: Double = 0.0
    
    var tuners: [Date:Tone.Tuner] = [:]
}

public class TonalTuneCenter: GraniteCenter<TonalTuneState> {
    public override var links: [GraniteLink] {
        [
            .relay(\TonalState.sentimentProgress,
                   \TonalTuneState.sentimentLoadingProgress)
        ]
    }
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    var tone: Tone {
        envDependency.tone
    }
    
    var tonalSentiment: TonalSentiment {
        tone.tune.sentiment ?? .empty
    }
    
    var sentimentIsAvailable: Bool {
        tone.tune.sentiment != nil
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            TonalTuneChangedExpedition.Discovery(),
            TuneTheToneExpedition.Discovery(),
        ]
    }
}
