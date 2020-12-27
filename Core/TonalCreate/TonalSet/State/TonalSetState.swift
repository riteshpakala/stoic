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
    var tonalRangeData: [TonalRange] {
        payload?.object as? [TonalRange] ?? []
    }
    
    var chunkedRangeDate: [[TonalRange]] {
        tonalRangeData.chunked(into: 2)
    }
}

public class TonalSetCenter: GraniteCenter<TonalSetState> {
}
