//
//  TonalControlState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/25/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalControlState: GraniteState {
    let tuner: SentimentSliderState
    var currentPrediction: TonalPrediction = .zero
    var model: TonalModel? = nil
    
    public init(_ tuner: SentimentSliderState, model: TonalModel?) {
        self.tuner = tuner
        self.model = model
        
        //TODO: This is not a very good practice
        if model != nil {
            self.model?.precompute()
        }
    }
    
    public required init() {
        tuner = .init(.neutral, date: .today)
        model = nil
    }
}

public class TonalControlCenter: GraniteCenter<TonalControlState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            TonalControlSentimentExpedition.Discovery()
        ]
    }
    
    lazy var basePlotData: (high: SomePlotData.PlotData, highSegments: [Int], low: SomePlotData.PlotData, lowSegments: [Int]) = {
        guard let last12Securities = state.model?.last12SecuritiesDailies.prefix(5) else {
            return ([], [], [], [])
        }
        
        //Compute High Visual
        let baseHighPlotData: SomePlotData.PlotData = last12Securities.map { ($0.date, $0.highValue.asCGFloat) }.reversed()
        
        let highSegs: [Int] = baseHighPlotData.enumerated().map { $0.offset }
        
        //Compute Low Visual
        let baseLowPlotData: SomePlotData.PlotData = last12Securities.map { ($0.date, $0.lowValue.asCGFloat) }.reversed()
        
        let lowSegs: [Int] = baseLowPlotData.enumerated().map { $0.offset }
        
        return (baseHighPlotData, highSegs, baseLowPlotData, lowSegs)
    }()
    
    var plotData: (high: SomePlotData, low: SomePlotData) {
       
        let predictionHighPlotData: SomePlotData.PlotData = [(Date.nextTradingDay, state.currentPrediction.high.asCGFloat)]
        
        let highSegments: [Int] = basePlotData.highSegments
        //Compile
        let high: SomePlotData = .init(basePlotData.high,
                                       predictionPlotData: predictionHighPlotData,
                                       segments: highSegments,
                                       interval: .daily,
                                       graphType: .price(.init(priceSize: .headline,
                                                               dateSize: .footnote,
                                                               dateValuePadding: Brand.Padding.large,
                                                               pricePadding: 0,
                                                               widthOfPriceViewIndicators: 165,
                                                               widthOfPriceView: 174)))
        
        let predictionLowPlotData: SomePlotData.PlotData = [(Date.nextTradingDay, state.currentPrediction.low.asCGFloat)]
        
        let lowSegments: [Int] = basePlotData.lowSegments
        //Compile
        let low: SomePlotData = .init(basePlotData.low,
                                      predictionPlotData: predictionLowPlotData,
                                      segments: lowSegments,
                                      interval: .daily,
                                      graphType: .price(.init(priceSize: .headline,
                                                              dateSize: .footnote,
                                                              dateValuePadding: Brand.Padding.large,
                                                              pricePadding: 0,
                                                              widthOfPriceViewIndicators: 165,
                                                              widthOfPriceView: 174)))
        
        return (high, low)
    }
}
