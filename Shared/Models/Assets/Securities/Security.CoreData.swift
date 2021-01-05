//
//  Security.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation
import GraniteUI

extension Security {
    public func apply(to quote: QuoteObject) {
        quote.exchangeName = exchangeName
        quote.ticker = ticker
        quote.intervalType = interval.rawValue
        quote.securityType = securityType.rawValue
    }
}

extension SecurityObject {
    public var asSecurity: Security? {
        let type = SecurityType.init(rawValue: self.securityType)
        
        switch type {
        case .stock:
            if let stockObject = self as? StockDataObject {
                return stockObject.asStock
            } else {
                
                return nil
            }
        case .crypto:
            if let cryptoObject = self as? CryptoDataObject {
                return cryptoObject.asCrypto
            } else {
                
                return nil
            }
        default:
            return nil
        }
        
    }
}

extension StockDataObject {
    public var asStock: Stock {
        .init(ticker: self.ticker,
              date: self.date,
              open: self.open,
              high: self.high,
              low: self.low,
              close: self.close,
              volume: self.volume,
              changePercent: self.changePercentValue,
              changeAbsolute: self.changeAbsoluteValue,
              interval: SecurityInterval(rawValue: self.intervalType) ?? .day,
              exchangeName: self.exchangeName)
    }
}

extension CryptoDataObject {
    public var asCrypto: CryptoCurrency {
        .init(ticker: self.ticker,
              date: self.date,
              last: self.lastValue,
              high: self.highValue,
              low: self.lowValue,
              volume: self.volumeValue,
              changePercent: self.changePercentValue,
              changeAbsolute: self.changeAbsoluteValue,
              interval: SecurityInterval(rawValue: self.intervalType) ?? .day,
              exchangeName: self.exchangeName)
    }
}
