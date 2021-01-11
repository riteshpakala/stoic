//
//  GraphState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class GraphState: GraniteState {
    var quote: Quote? = nil
    
    public init(_ quote: Quote?) {
        self.quote = quote
    }
    
    public required init() {
        self.quote = nil
    }
}

public class GraphCenter: GraniteCenter<GraphState> {
    var plotData: SomePlotData {
        if let quote = state.quote {
            let data: GraphPageViewModel.PlotData = quote.daily().sortAsc.map { ($0.date, $0.lastValue.asCGFloat) }
//            for security in quote.securities {
//                print("{TES}T \(security.date)")
//            }
            let some: SomePlotData = .init()
            some.plotData = data
            return some
        } else {
            return .init()
        }
    }
}

