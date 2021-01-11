//
//  TonalCompileState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalCompileState: GraniteState {
    var tune: SentimentOutput = .neutral
    var currentPrediction: Double = 0.0
}

public class TonalCompileCenter: GraniteCenter<TonalCompileState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    var tone: Tone {
        envDependency.tone
    }
    
    var tonalCompile: Tone.Compile {
        tone.compile
    }
    
    var compileState: Tone.Compile.State {
        tonalCompile.state
    }
    
    override public var expeditions: [GraniteBaseExpedition] {
        [
            CompileTheToneExpedition.Discovery(),
            SaveTheToneExpedition.Discovery(),
            PredictTheToneExpedition.Discovery()
        ]
    }
}
