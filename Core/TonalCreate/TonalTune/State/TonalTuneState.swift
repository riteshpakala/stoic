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
    var tone: Tone {
        payload?.object as? Tone ?? .init()
    }
    
    var tonalSentiment: TonalSentiment {
        tone.sentiment ?? .empty
    }
}

public class TonalTuneCenter: GraniteCenter<TonalTuneState> {
}
