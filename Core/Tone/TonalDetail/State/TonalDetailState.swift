//
//  TonalDetailState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/14/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalDetailStage {
    case generating
    case none
}
public class TonalDetailState: GraniteState {
    let model: TonalModel?
    var tuner: SentimentSliderState = .init(.neutral, date: .today)
    
    public init(_ model: TonalModel?) {
        self.model = model
    }
    
    public required init() {
        model = nil
    }
}

public class TonalDetailCenter: GraniteCenter<TonalDetailState> {
    let tonalRelay: TonalRelay = .init()
    
    @GraniteDependency
    var detailDependency: DetailDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GenerateTonesExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalDetailEvents.Generate())
        ]
    }
}
