//
//  Portfolio.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import CoreData
import GraniteUI
import SwiftUI

extension NSManagedObjectContext {
    public func pullPortfolios() -> [PortfolioObject]? {
        let result: [PortfolioObject]? = self.performAndWaitPlease { [weak self] in
            do {
                if let objects = try self?.fetch(PortfolioObject.request()) {
                    return objects
                } else {
                    return nil
                }
            } catch let error {
                return nil
            }
        }
        
        return result
    }
    
    public func getPortfolioObject(_ username: String) -> PortfolioObject? {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        let result: PortfolioObject? = self.performAndWaitPlease { [weak self] in
            do {
                if let object = try self?.fetch(request).first {
                    return object
                } else {
                    return nil
                }
            } catch let error {
                return nil
            }
        }
        
        return result
    }
    
    public func getPortfolio(username: String) -> Portfolio? {
        let obj = self.getPortfolioObject(username)
        return obj?.asPortfolio
    }
    
    func resetStrategy(username: String) -> Portfolio? {
        let object = self.getPortfolioObject(username)
        let result: Portfolio? = self.performAndWaitPlease { [weak self] in
            do {
                //We are only using 1 strategy for now
                //otherwise we would need to specify the strategy
                if let strategy = object?.strategies?.first {
                    strategy.date = .today
                    strategy.name = strategy.date.asString
                    
                    object?.strategies = [strategy]
                    
                    if let investments = strategy.investmentData?.investments {
                        investments.items.forEach { item in
                            item.closed = false
                        }
                        
                        strategy.investmentData = investments.archived
                    }
                    
                    try self?.save()
                    
                    
                    
                    return object?.asPortfolio
                } else {
                    return nil
                }
            } catch let error {
                return nil
            }
        }
        
        return result
    }
    
    func removeFromStrategy(username: String,
                            _ security: Security) -> Portfolio? {
        let object = self.getPortfolioObject(username)
        let result: Portfolio? = self.performAndWaitPlease { [weak self] in
            do {
                //We are only using 1 strategy for now
                //otherwise we would need to specify the strategy
                if let strategy = object?.strategies?.first {
                    
                    if let quote = strategy.quotes?.first(where: { $0.contains(security: security) }) {
                        
                        strategy.removeFromQuotes(quote)
                        if let investments = strategy.investmentData?.investments {
                            investments.items.removeAll(where: { $0.ticker == quote.ticker })
                            
                            strategy.investmentData = investments.archived
                            
                            
                            try self?.save()
                        }
                    }
                    
                    return object?.asPortfolio
                } else {
                    return nil
                }
            } catch let error {
                return nil
            }
        }
        
        return result
    }
    
    func closeFromStrategy(username: String,
                            _ security: Security) -> Portfolio? {
        
        let object = self.getPortfolioObject(username)
        let result: Portfolio? = self.performAndWaitPlease { [weak self] in
            do {
                //We are only using 1 strategy for now
                //otherwise we would need to specify the strategy
                if let strategy = object?.strategies?.first,
                   let investments = strategy.investmentData?.investments,
                   let index = investments.items.firstIndex(where: { $0.assetID == security.assetID }){
                    
                    investments.items[index].closed = true
                    investments.items[index].closedChange = investments.items[index].latestChange
                    
                    strategy.investmentData = investments.archived
                    
                    try self?.save()
                } else {
                    return nil
                }
                
                return object?.asPortfolio
            } catch let error {
                return nil
            }
        }
        
        return result
    }
}

extension Portfolio {

    func addToStrategy(_ securities: [Security],
                       moc: NSManagedObjectContext) -> Portfolio? {
        let object = moc.getPortfolioObject(username)
        let result: Portfolio? = moc.performAndWaitPlease { [weak self] in
            do {
                
                let quoteRequest: NSFetchRequest = QuoteObject.fetchRequest()
                let quoteObjects = try moc.fetch(quoteRequest)
                var quotes = quoteObjects.filter( { quote in securities.filter({ quote.contains(security: $0) }).isNotEmpty } )
                let quotesMissing = securities.filter( { sec in quotes.filter({ $0.contains(security: sec) }).isEmpty } )
                
                if quotesMissing.isNotEmpty {
                    for security in quotesMissing {
                        let securityRequest = security.getObjectRequest()
                        
                        if let first = try? moc.fetch(securityRequest).first {
                            let quote = QuoteObject.init(context: moc)
                            security.apply(to: quote)
                            quote.addToSecurities(first)
                            first.quote = quote
                            quotes.append(quote)
                        }
                    }
                }
                
                //createst investments objects
                //of the newly added securities
                let investments: Strategy.Investments = .init(items: securities.map { $0.asInvestmentItem })
                
                let strategyToModify: StrategyObject
                if let strategy = object?.strategies?.first {
                    strategyToModify = strategy
                    
                    if let oldInvestments = strategy.investmentData?.investments {
                        oldInvestments.items.append(contentsOf: investments.items)
                        
                        strategyToModify.investmentData = oldInvestments.archived
                    }
                } else {
                    let strategy = StrategyObject.init(context: moc)
                    strategyToModify = strategy
                    strategyToModify.date = Date.today
                    strategyToModify.name = Date.today.simple.asString
                    strategyToModify.investmentData = investments.archived
                }
                strategyToModify.portfolio = object
                for quote in quotes {
                    strategyToModify.removeFromQuotes(quote)
                    strategyToModify.addToQuotes(quote)
                    quote.strategy = strategyToModify
                }
                
                object?.removeFromStrategies(strategyToModify)
                object?.addToStrategies(strategyToModify)
                
                try moc.save()
                
                return object?.asPortfolio
            } catch let error {
                return nil
            }
        }
        
        return result
    }
}

extension PortfolioObject {
    public var asPortfolio: Portfolio {
        
        return .init(self.username,
                     .init(Array(self.securities?.latests ?? .init()).asSecurities),
                     self.floor?.compactMap( { $0.asFloor } ) ?? [],
                     self.strategies?.compactMap( { $0.asStrategy.name }) ?? []
                     )
    }
    
    public static func hasSecurity(moc: NSManagedObjectContext,
                                   username: String) -> Bool {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        let exists: Bool = moc.performAndWaitPlease {
            do {
                let objects = try moc.fetch(request)
                
                return objects.isNotEmpty
            } catch let error {
                return false
            }
        }
        
        return exists
    }
}
