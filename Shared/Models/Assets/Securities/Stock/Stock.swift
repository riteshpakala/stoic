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
    public var interval: SecurityInterval
    public var exchangeName: String
    public var name: String
    public var hasStrategy: Bool
    public var hasPortfolio: Bool
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
    
    public var metadata1: String {
        self.name
    }
    
    public var metadata2: String {
        self.exchangeName
    }
}

//MARK: -- Extensions

//extension StockData {
//    public var asStock: Stock {
//        return .init(
//            ticker: symbolName,
//            date: dateData.asDate ?? Date(),
//            open: open,
//            high: high,
//            low: low,
//            close: close,
//            volume: volume,
//            changePercent: (close - lastStockData.close) / close,
//            changeAbsolute: (close - lastStockData.close))
//    }
//}

extension StockServiceModels.Quotes.QuoteResponse.QuoteResult {
    public func asStock(interval: SecurityInterval = .day) -> Stock {
            let open: Double = regularMarketPrice ?? 0.0
            let high: Double = regularMarketDayHigh ?? 0.0
            let low: Double = regularMarketDayLow ?? 0.0
            let close: Double = regularMarketPrice ?? 0.0
            let volume: Double = Double(regularMarketVolume ?? 0)
        
        return Stock.init(
            ticker: symbol,
            date: Date(),
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            changePercent: (regularMarketChangePercent ?? 0.0)/100,
            changeAbsolute: (regularMarketChange ?? 0.0),
            interval: interval,
            exchangeName: exchange,//TODO:??
            name: shortName,
            hasStrategy: false,
            hasPortfolio: false)
    }
}

extension StockServiceModels.Search.Stock {
    public func asStock(interval: SecurityInterval = .day) -> Stock {
        let open: Double = 0.0
        let high: Double = 0.0
        let low: Double = 0.0
        let close: Double = 0.0
        let volume: Double = 0.0
    
    return Stock.init(
        ticker: self.symbolName,
        date: Date(),
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
        changePercent: 0.0,
        changeAbsolute: 0.0,
        interval: interval,
        exchangeName: self.exchangeName,//TODO:??
        name: self.companyName,
        hasStrategy: false,
        hasPortfolio: false)
    }
}

extension StockServiceModels.Stock {
    public func asStocks(interval: SecurityInterval = .day) -> [Stock] {
        guard let result = chart.result.first else { return [] }
        
        guard let quote = result.indicators.quote.first else { return [] }
        
        let smallestArray = min(quote.close.count, min(quote.high.count, min(quote.low.count, min(quote.open.count, quote.volume.count))))
        
        var stocks: [Stock] = []
        for index in 0..<smallestArray {
            let close = quote.close[index] ?? 0.0
            
            let lastClose = index - 1 > 0 ? quote.close[index - 1] ?? close : close
            
            let changePercent = (close - lastClose) / close
            let changeAbsolue = close - lastClose
            
            let stock: Stock = .init(
                ticker: result.meta.symbol,
                date: Double(result.timestamp[index]).date(),
                open: quote.open[index] ?? 0.0,
                high: quote.high[index] ?? 0.0,
                low: quote.low[index] ?? 0.0,
                close: close,
                volume: quote.volume[index] ?? 0.0,
                changePercent: changePercent,
                changeAbsolute: changeAbsolue,
                interval: interval,
                exchangeName: result.meta.exchangeName,
                name: result.meta.symbol,
                hasStrategy: false,
                hasPortfolio: false)
            
            stocks.append(stock)
        }
        
        return stocks
    }
}
