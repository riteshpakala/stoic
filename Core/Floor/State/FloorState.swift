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
    var activeQuotes: [[Quote?]] = []
    var floorStage: FloorStage = .none
    var floors: [Floor] = []
}

public class FloorCenter: GraniteCenter<FloorState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    let tonalRelay: TonalRelay = .init()
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var links: [GraniteLink] {
        [
            .onAppear(FloorEvents.Get()),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetFloorExpedition.Discovery(),
            AddToFloorExpedition.Discovery(),
            ExitAddToFloorExpedition.Discovery()
        ]
    }
    
    public var environmentIPhoneSize: CGSize {
        return .init(width: .infinity,
                     height: (envDependency.envSettings.lf?.data.height ?? EnvironmentConfig.iPhoneScreenHeight))
    }
}
