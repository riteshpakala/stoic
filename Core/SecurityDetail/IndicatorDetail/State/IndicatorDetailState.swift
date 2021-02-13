//
//  IndicatorDetailState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/21/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class IndicatorDetailState: GraniteState {
    let quote: Quote?
    
    public init(_ quote: Quote?) {
        self.quote = quote
    }
    
    public required init() {
        quote = nil
    }
}

public class IndicatorDetailCenter: GraniteCenter<IndicatorDetailState> {
    let tonalRelay: TonalRelay = .init()
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GenerateIndicatorExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(IndicatorDetailEvents.Generate(), .dependant)
        ]
    }
    
    lazy var stochastics: TonalServiceModels.Indicators.Stochastics? = {
        guard let quote = state.quote else { return nil }
        return TonalServiceModels.Indicators.init(with: quote).stochastic
    }()
    
    var plotData: (percentK: SomePlotData, percentD: SomePlotData) {
        if let stochastics = self.stochastics {
            var dataK: GraphPageViewModel.PlotData = .init()
            var dataD: GraphPageViewModel.PlotData = .init()
            let Ks = stochastics.values.absoluteKs
            let Ds = stochastics.values.absoluteDs
            for (index) in 0..<stochastics.values.count {
                let K = Ks[index]
                let D = Ds[index]
                let date = stochastics.values.dates[index]
                
                dataK.append((date, K.asCGFloat))
                dataD.append((date, D.asCGFloat))
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
        .daily
    }
}
