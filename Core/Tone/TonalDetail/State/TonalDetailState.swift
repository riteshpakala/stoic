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

public class TonalDetailState: GraniteState {
    let quote: Quote?
    
    public init(_ quote: Quote?) {
        self.quote = quote
    }
    
    public required init() {
        quote = nil
    }
}

public class TonalDetailCenter: GraniteCenter<TonalDetailState> {
    let tonalRelay: TonalRelay = .init()
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GenerateTonesExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalDetailEvents.Generate(), .dependant)
        ]
    }
    
    var stochastics: TonalServiceModels.Indicators.Stochastics? {
        envDependency.detail.indicators?.stochastic
    }
    
    var plotData: (percentK: SomePlotData, percentD: SomePlotData) {
        if let stochastics = self.stochastics {
            var dataK: GraphPageViewModel.PlotData = .init()
            var dataD: GraphPageViewModel.PlotData = .init()
            for (index) in 0..<stochastics.values.count {
                let percentK = stochastics.values.percentKs[index]
                let percentD = stochastics.values.percentDs[index]
                let date = stochastics.values.dates[index]
                
                dataK.append((date, percentK.asCGFloat))
                dataD.append((date, percentD.asCGFloat))
            }
            
            let plotDataK: SomePlotData = .init(dataK.reversed(),
                                                interval: timeDisplay,
                                                graphType: .indicator(Brand.Colors.grey))
            
            let plotDataD: SomePlotData = .init(dataD.reversed(),
                                                interval: timeDisplay,
                                                graphType: .indicator(Brand.Colors.yellow))
            return (plotDataK, plotDataD)
        } else {
            return (.init(), .init())
        }
    }
    
    var timeDisplay: TimeDisplayOption {
        if let quote = state.quote {
            switch quote.intervalType {
            case .day:
                return .daily
            case .hour:
                return .hourly
            }
        } else {
            return .daily
        }
    }
}
