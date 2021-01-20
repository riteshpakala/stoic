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
    public struct Search: GraniteEvent {
        let query: String
        public init(_ query: String) {
            self.query = query
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct SearchDataResult: GraniteEvent {
        let data: [StockServiceModels.Search]
    }
    
    public struct SearchQuoteResults: GraniteEvent {
        let quotes: [StockServiceModels.Quotes]
    }
    
    public struct SearchResult: GraniteEvent {
        let result: [Security]
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    //MARK: -- Movers
    public struct GetMovers: GraniteEvent {
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct MoversData: GraniteEvent {
        let data: [StockServiceModels.Movers]
    }
    
    public struct MoverStockQuotes: GraniteEvent {
        let movers: StockServiceModels.Movers
        let quotes: [StockServiceModels.Quotes]
    }
    
    public struct GlobalCategoryResult: GraniteEvent {
        let losers: [Security]
        let gainers: [Security]
        let topVolume: [Security]
        
        public init(_ topVolume: [Security],
                    _ gainers: [Security],
                    _ losers: [Security]) {
            self.topVolume = topVolume
            self.gainers = gainers
            self.losers = losers
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    //MARK: -- Stock History
    public struct GetStockHistory: GraniteEvent {
        let security: Security
        let interval: SecurityInterval
        let daysAgo: Int
        
        public init(security: Security,
                    daysAgo: Int = 2400,
                    interval: SecurityInterval = .day)//730 = 2 years - 1825 = 5 years
        {
            self.security = security
            self.interval = interval
            self.daysAgo = daysAgo
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    //MARK: -- Stock Interval
    public struct GetStockInterval: GraniteEvent {
        let symbol: String
        let fromDate: Int64
        let toDate: Int64
        let interval: SecurityInterval
        
        public init(symbol: String, fromDate: Int64, toDate: Int64, interval: SecurityInterval)
        {
            self.symbol = symbol
            self.fromDate = fromDate
            self.toDate = toDate
            self.interval = interval
        }
    }
    
    public struct History: GraniteEvent {
        let data: [Stock]
        let interval: SecurityInterval
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct Interval: GraniteEvent {
        let data: [StockServiceModels.Stock]
        let interval: SecurityInterval
    }
    
    //MARK: -- Misc
    public struct GetTradingDay: GraniteEvent {
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    public struct TradingDayResult: GraniteEvent {
        let data: [StockServiceModels.TradingDay]
    }
    public struct TradingDay: GraniteEvent {
        let data: StockServiceModels.TradingDay
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
}

