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
            changeAbsolute: regularMarketChange ?? 0.0,
            interval: interval,
            exchangeName: "")//TODO:
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
            let lastClose = index + 1 < quote.close.count ? quote.close[index + 1] ?? close : close
            
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
                exchangeName: result.meta.exchangeName)
            
            stocks.append(stock)
        }
        
        return stocks
    }
}

//extension SecurityObject {
//    public func asStocks(interval: SecurityInterval = .day) -> Security {
//        return Stock.init(ticker: ticker, date: date, open: dat, high: <#T##Double#>, low: <#T##Double#>, close: <#T##Double#>, volume: <#T##Double#>, changePercent: <#T##Double#>, changeAbsolute: <#T##Double#>, interval: <#T##SecurityInterval#>, exchangeName: <#T##String#>)
//    }
//}
