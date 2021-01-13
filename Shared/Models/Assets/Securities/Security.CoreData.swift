//
//  Security.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation
import GraniteUI
import CoreData
import CoreGraphics

extension Security {
    public func apply(to quote: QuoteObject) {
        quote.exchangeName = exchangeName
        quote.ticker = ticker
        quote.intervalType = interval.rawValue
        quote.securityType = securityType.rawValue
    }
    
    public func apply(to security: SecurityObject) {
        security.exchangeName = exchangeName
        security.ticker = ticker
        security.indicator = self.indicator
        security.intervalType = interval.rawValue
        security.securityType = securityType.rawValue
        security.lowValue = self.lowValue
        security.highValue = self.highValue
        security.lastValue = self.lastValue
        security.changePercentValue = self.changePercentValue
        security.changeAbsoluteValue = self.changeAbsoluteValue
        security.volumeValue = self.volumeValue
        security.date = self.date
        
    }
    
    public func record(to moc: NSManagedObjectContext) -> SecurityObject? {
        switch self.securityType {
        case .crypto:
            let object = CryptoDataObject(context: moc)
            if let crypto = self as? CryptoCurrency {
                crypto.apply(to: object)
                return object
            } else {
                return nil
            }
        case .stock:
            let object = StockDataObject(context: moc)
            if let stock = self as? Stock {
                stock.apply(to: object)
                return object
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    public func getObject(moc: NSManagedObjectContext,
                          _ completion: @escaping ((SecurityObject?) -> Void)) {
        let request: NSFetchRequest = SecurityObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date == %@) AND (ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.date as NSDate,
                                        self.ticker,
                                        self.exchangeName,
                                        self.interval.rawValue)
        
        moc.performAndWait {
            completion(try? moc.fetch(request).first)
        }
    }
    
    public func getQuoteObject(moc: NSManagedObjectContext,
                               _ completion: @escaping ((QuoteObject?) -> Void)) {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.ticker,
                                        self.exchangeName,
                                        self.interval.rawValue)
        moc.performAndWait {
            completion(try? moc.fetch(request).first)
        }
    }
    
    public func getQuote(moc: NSManagedObjectContext,
                         _ completion: @escaping ((Quote?) -> Void)){
        getQuoteObject(moc: moc) { quoteObject in
            completion(quoteObject?.asQuote)
        }
    }
    
    public func addToPortfolio(username: String = "test",
                               moc: NSManagedObjectContext,
                               _ added: @escaping ((Portfolio?) -> Void)) {
        moc.performAndWait {
            guard let recordedSecurity = self.record(to: moc) else { added(nil); return }
                
            moc.getPortfolioObject(username) { portfolioObject in
                do {
                    if let portfolio = portfolioObject {
                        portfolio.addToSecurities(recordedSecurity)
                        try moc.save()
                        added(portfolio.asPortfolio)
                    } else {
                        let newPortfolio = PortfolioObject.init(context: moc)
                        newPortfolio.username = username
                        newPortfolio.addToSecurities(recordedSecurity)
                        try moc.save()
                        added(newPortfolio.asPortfolio)
                    }
                } catch let error {
                    added(nil)
                    print("⚠️ Error adding to portfolio \(error)")
                }
            }
        }
    }
    
    public func addToFloor(username: String = "test",
                           location: CGPoint,
                           moc: NSManagedObjectContext,
                           _ added: @escaping ((Portfolio?) -> Void)) {
        moc.performAndWait {
            
            guard let recordedSecurity = self.record(to: moc) else { added(nil); return }
            let floor = FloorObject(context: moc)
            floor.coordX = Int32(location.x)
            floor.coordY = Int32(location.y)
            floor.security = recordedSecurity
            
            moc.getPortfolioObject(username) { portfolioObject in
                do {
                    if let portfolio = portfolioObject {
                        portfolio.addToSecurities(recordedSecurity)
                        floor.portfolio = portfolio
                        portfolio.addToFloor(floor)
                        try moc.save()
                        added(portfolio.asPortfolio)
                    } else {
                        let portfolio = PortfolioObject.init(context: moc)
                        portfolio.username = username
                        portfolio.addToSecurities(recordedSecurity)
                        floor.portfolio = portfolio
                        portfolio.addToFloor(floor)
                        try moc.save()
                        added(portfolio.asPortfolio)
                    }
                } catch let error {
                    added(nil)
                    print("⚠️ Error adding to portfolio \(error)")
                }
            }
        }
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
