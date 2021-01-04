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
    var tone: Tone {
        payload?.object as? Tone ?? .init()
    }
    
    var ticker: String? {
        tone.ticker
    }
    
    var tonalRangeData: [TonalRange] {
        tone.range ?? []
    }
}

public class TonalSetCenter: GraniteCenter<TonalSetState> {
    var tonalCreateDependency: TonalCreateDependency {
        return dependency.hosted as? TonalCreateDependency ?? .init(identifier: "none")
    }
    
    var tone: Tone {
        tonalCreateDependency.tone
    }
    
    var ticker: String? {
        tone.ticker
    }
    
    var tonalRangeData: [TonalRange] {
        tone.range ?? []
    }
}
