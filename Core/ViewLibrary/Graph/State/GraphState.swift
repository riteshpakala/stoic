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
    var securities: [Security] = []
    
    public init(_ quote: Quote?) {
        self.quote = quote
        
        switch quote?.securityType {
        case .stock:
            securities = quote?.daily(count: 60).sortAsc ?? []
        case .crypto:
            securities = quote?.intraday(count: 120).sortAsc ?? []
        default:
            break
        }
    }
    
    public required init() {
        self.quote = nil
    }
}

public class GraphCenter: GraniteCenter<GraphState> {
    var plotData: SomePlotData {
        let data: GraphPageViewModel.PlotData = state.securities.map { ($0.date, $0.lastValue.asCGFloat) }
        
        return .init(data, interval: timeDisplay, graphType: .price(.basic))
    }
    
    var timeDisplay: TimeDisplayOption {
        switch state.quote?.securityType {
        case .crypto:
            return .hourly
        default:
            return .daily
        }
    }
}

