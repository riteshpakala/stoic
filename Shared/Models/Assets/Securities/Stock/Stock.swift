//
//  Stock.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation

public struct Stock: Security {
    public var ticker: String
    public var date: Date
    public var open: Double
    public var high: Double
    public var low: Double
    public var close: Double
    public var volume: Double
    public var changePercent: Double
    public var changeAbsolute: Double
}

extension Stock {
    public var indicator: String {
        "$"
    }
    
    public var securityType: SecurityType {
        .stock
    }
    
    public var lastValue: Double {
        close
    }
    
    public var highValue: Double {
        high
    }
    
    public var lowValue: Double {
        low
    }
    
    public var volumeValue: Double {
        volume
    }
    
    public var changePercentValue: Double {
        changePercent
    }
    
    public var changeAbsoluteValue: Double {
        changeAbsolute
    }
}

//MARK: -- Extensions

extension StockData {
    public var asStock: Stock {
        return .init(
            ticker: symbolName,
            date: dateData.asDate ?? Date(),
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            changePercent: (close - lastStockData.close) / close,
            changeAbsolute: (close - lastStockData.close))
    }
}

extension StockServiceModels.Quotes.QuoteResponse.QuoteResult {
    public var asStock: Stock {
            let open: Double = regularMarketPrice ?? 0.0
            let high: Double = regularMarketDayHigh ?? 0.0
            let low: Double = regularMarketDayHigh ?? 0.0
            let close: Double = regularMarketDayLow ?? 0.0
            let volume: Double = Double(regularMarketVolume ?? 0)
        
        return Stock.init(
            ticker: symbol,
            date: Date(),
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            changePercent: regularMarketChangePercent ?? 0.0,
            changeAbsolute: regularMarketChange ?? 0.0)
    }
}
