//
//  Security.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation
import GraniteUI
import CoreData

extension Security {
    public func apply(to quote: QuoteObject) {
        quote.exchangeName = exchangeName
        quote.ticker = ticker
        quote.intervalType = interval.rawValue
        quote.securityType = securityType.rawValue
    }
    
    public func getObject(moc: NSManagedObjectContext) -> SecurityObject? {
        let request: NSFetchRequest = SecurityObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date == %@) AND (ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.date as NSDate,
                                        self.ticker,
                                        self.exchangeName,
                                        self.interval.rawValue)
        return try? moc.fetch(request).first
    }
    
    public func getQuoteObject(moc: NSManagedObjectContext) -> QuoteObject? {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.ticker,
                                        self.exchangeName,
                                        self.interval.rawValue)
        return try? moc.fetch(request).first
    }
    
    public func getQuote(moc: NSManagedObjectContext) -> Quote? {
        return getQuoteObject(moc: moc)?.asQuote
    }
}

extension Array where Element == SecurityObject {
    var asSecurities: [Security] {
        self.compactMap { $0.asSecurity }
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
