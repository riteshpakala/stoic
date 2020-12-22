//
//  StockEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StockEvents {
    public struct GetMovers: GraniteEvent {}
    public struct MoversData: GraniteEvent {
        let data: [StockServiceModels.Movers]
    }
    public struct MoverStockQuotes: GraniteEvent {
        let movers: StockServiceModels.Movers
        let quotes: [StockServiceModels.Quotes]
    }
    
    public struct GlobalCategoryResult: GraniteEvent {
        let losers: [Stock]
        let gainers: [Stock]
        let topVolume: [Stock]
        
        public init(_ topVolume: [Stock],
                    _ gainers: [Stock],
                    _ losers: [Stock]) {
            self.topVolume = topVolume
            self.gainers = gainers
            self.losers = losers
        }
    }
    
    //
    public struct StockTradingDay: GraniteEvent {
    }
    
    public struct UpdateStockData: GraniteEvent {
    }
    
    public struct NewStockData: GraniteEvent {
        let data: [StockData]
    }
}

