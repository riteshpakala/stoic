//
//  FloorState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum FloorStage: Equatable {
    case none
    case adding(CGPoint)
}

public class FloorState: GraniteState {
    var activeSecurities: [[Security?]] = []
    var floorStage: FloorStage = .none
}

public class FloorCenter: GraniteCenter<FloorState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    let tonalRelay: TonalRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(FloorEvents.Get(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetFloorExpedition.Discovery(),
            AddToFloorExpedition.Discovery()
        ]
    }
}
