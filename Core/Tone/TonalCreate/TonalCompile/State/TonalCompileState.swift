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

    @GraniteInject
    var toneDependency: ToneDependency
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    var tone: Tone {
        toneDependency.tone
    }
    
    var latestSecurity: Security? {
        tone.latestSecurity
    }
    
    var quote: Quote? {
        tone.find.quote
    }
    
    var tonalCompile: Tone.Compile {
        tone.compile
    }
    
    var compileState: Tone.Compile.State {
        tonalCompile.state
    }
    
    var model: TonalModel? {
        tonalCompile.tonalModel
    }
    
    override public var expeditions: [GraniteBaseExpedition] {
        [
            CompileTheToneExpedition.Discovery(),
            SaveTheToneExpedition.Discovery(),
            PredictTheToneExpedition.Discovery()
        ]
    }
}
