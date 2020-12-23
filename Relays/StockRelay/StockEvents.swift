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
    //MARK: -- Movers
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
    
    //MARK: -- Stock History
    public struct GetStockHistory: GraniteEvent {
        let symbol: String
        let daysAgo: Int
        
        public init(symbol: String, daysAgo: Int = 120)//730 = 2 years - 1825 = 5 years
        {
            self.symbol = symbol
            self.daysAgo = daysAgo
        }
    }
    public struct StockHistory: GraniteEvent {
        let data: [StockData]
    }
    
    //MARK: -- Misc
    public struct StockTradingDay: GraniteEvent {
    }
}

