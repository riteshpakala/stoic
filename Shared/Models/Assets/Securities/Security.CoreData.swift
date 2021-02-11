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
        quote.securityType = securityType.rawValue
        quote.name = name
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
    
    public func record(to moc: NSManagedObjectContext) -> (SecurityObject, Bool)? {
        guard let object = try? moc.fetch(self.getObjectRequest()).first else {
            switch self.securityType {
            case .crypto:
                let object = CryptoDataObject(context: moc)
                if let crypto = self as? CryptoCurrency {
                    crypto.apply(to: object)
                    return (object, false)
                } else {
                    return nil
                }
            case .stock:
                let object = StockDataObject(context: moc)
                if let stock = self as? Stock {
                    stock.apply(to: object)
                    return (object, false)
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
        
        return (object, true)
    }
    
    public func getObjectRequest() -> NSFetchRequest<SecurityObject> {
        let request: NSFetchRequest = SecurityObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date == %@) AND (ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.date as NSDate,
                                        self.ticker,
                                        self.exchangeName,
                                        self.interval.rawValue)
        
        return request
    }
    
    public func getObject(moc: NSManagedObjectContext,
                          _ completion: @escaping ((SecurityObject?) -> Void)) {
        let request: NSFetchRequest = self.getObjectRequest()
        
        moc.performAndWait {
            completion(try? moc.fetch(request).first)
        }
    }
    
    public func getQuoteObject(moc: NSManagedObjectContext,
                               _ completion: @escaping ((QuoteObject?) -> Void)) {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (name == %@)",
                                        self.ticker,
                                        self.name)
        
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
    
    public func addToPortfolio(username: String,
                               moc: NSManagedObjectContext,
                               _ added: @escaping ((Portfolio?) -> Void)) {
        moc.performAndWait {
            guard let recordedSecurityPayload = self.record(to: moc) else { added(nil); return }
            
            let recordedSecurity = recordedSecurityPayload.0
            
            //Create quote if possible to record security to it
            //otherwise its a dangling security
            do {
                let quotes: [QuoteObject] = try moc.fetch(QuoteObject.fetchRequest())
                
                let quote: QuoteObject = quotes.first(where: { $0.contains(security: self) }) ?? QuoteObject.init(context: moc)
                
                self.apply(to: quote)
                recordedSecurity.quote = quote
                quote.addToSecurities(recordedSecurity)
            } catch let error {
                GraniteLogger.error("failed createing a quote before adding to portfolio\(error.localizedDescription)", .expedition)
            }
            
            moc.getPortfolioObject(username) { portfolioObject in
                do {
                    if let portfolio = portfolioObject {
                        guard portfolio.securities?.filter({ $0.name == self.name })
                                .isEmpty == true else { added(nil); return }
                        
                        recordedSecurity.portfolio = portfolio
                        portfolio.addToSecurities(recordedSecurity)
                        try moc.save()
                        added(portfolio.asPortfolio)
                    } else {
                        let newPortfolio = PortfolioObject.init(context: moc)
                        newPortfolio.username = username
                        recordedSecurity.portfolio = newPortfolio
                        newPortfolio.addToSecurities(recordedSecurity)
                        try moc.save()
                        added(newPortfolio.asPortfolio)
                    }
                } catch let error {
                    GraniteLogger.error("failed adding to portfolio\(error.localizedDescription)", .expedition)
                    added(nil)
                }
            }
        }
    }
    
    public func addToFloor(username: String,
                           location: CGPoint,
                           moc: NSManagedObjectContext,
                           _ added: @escaping ((Portfolio?) -> Void)) {
        moc.performAndWait {
            guard let recordedSecurityPayload = self.record(to: moc) else { added(nil); return }
            
            let recordedSecurity = recordedSecurityPayload.0
            
            //Create quote if possible to record security to it
            //otherwise its a dangling security
            do {
                let quotes: [QuoteObject] = try moc.fetch(QuoteObject.fetchRequest())
                
                let quote: QuoteObject = quotes.first(where: { $0.contains(security: self) }) ?? QuoteObject.init(context: moc)
                
                self.apply(to: quote)
                recordedSecurity.quote = quote
                quote.addToSecurities(recordedSecurity)
            } catch let error {
                GraniteLogger.error("failed createing a quote before adding to portfolio\(error.localizedDescription)", .expedition)
            }
            
            moc.getPortfolioObject(username) { portfolioObject in
                do {
                    let floor: FloorObject
                    
                    if let portfolio = portfolioObject {
                        if let floorFound = portfolio.floor?.first(where: { $0.security?.name == recordedSecurity.name }) {
                            floor = floorFound
                        } else {
                            floor = FloorObject(context: moc)
                            recordedSecurity.portfolio = portfolio
                            recordedSecurity.floor = floor
                            floor.portfolio = portfolio
                            portfolio.addToFloor(floor)
                        }
                        
                        if !recordedSecurityPayload.1,
                           portfolio.securities?.filter({ $0.name == self.name })
                            .isEmpty == true {
                            portfolio.addToSecurities(recordedSecurity)
                        }
                        
                        floor.coordX = Int32(location.x)
                        floor.coordY = Int32(location.y)
                        
                        try moc.save()
                        added(portfolio.asPortfolio)
                    } else {
                        floor = FloorObject(context: moc)
                        floor.coordX = Int32(location.x)
                        floor.coordY = Int32(location.y)
                        floor.security = recordedSecurity
                        
                        let portfolio = PortfolioObject.init(context: moc)
                        portfolio.username = username
                        recordedSecurity.portfolio = portfolio
                        recordedSecurity.floor = floor
                        portfolio.addToSecurities(recordedSecurity)
                        floor.portfolio = portfolio
                        portfolio.addToFloor(floor)
                        try moc.save()
                        added(portfolio.asPortfolio)
                    }
                } catch let error {
                    GraniteLogger.error("failed adding to portfolio\(error.localizedDescription)", .expedition)
                    added(nil)
                }
            }
        }
    }
    
    public var asInvestmentItem: Strategy.Investments.Item {
        .init(security: self)
    }
}

extension Array where Element == Security {
    func recordedObjects(moc: NSManagedObjectContext) -> [SecurityObject] {
        self.compactMap { $0.record(to: moc)?.0 }
    }
}

extension Array where Element == SecurityObject {
    var asSecurities: [Security] {
        self.compactMap { $0.asSecurity }
    }
    
    var latests: [SecurityObject] {
        return self.compactMap { security in
            if let securities = security.quote?.securities {
                return Array(securities).sortDesc.first
            } else {
                return security
            }
        }
    }
}

extension Set where Element == SecurityObject {
    var latests: [SecurityObject] {
        self.compactMap { security in
            if let securities = security.quote?.securities {
                return Array(securities).sortDesc.first
            } else {
                return security
            }
        }
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
              exchangeName: self.exchangeName,
              name: self.name,
              hasStrategy: self.hasStrategy,
              hasPortfolio: self.hasPortfolio)
    }
}

extension CryptoDataObject {
    public var asCrypto: CryptoCurrency {
        .init(ticker: self.ticker,
              date: self.date,
              open: self.open,
              close: self.close,
              high: self.high,
              low: self.low,
              volumeBTC: self.volumeBTC,
              volume: self.volume,
              changePercent: self.changePercentValue,
              changeAbsolute: self.changeAbsoluteValue,
              interval: SecurityInterval(rawValue: self.intervalType) ?? .hour,
              exchangeName: self.exchangeName,
              name: self.name,
              hasStrategy: self.hasStrategy,
              hasPortfolio: self.hasPortfolio)
    }
}
