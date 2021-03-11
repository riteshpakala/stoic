//
//  Strategy.CoreData.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/15/21.
//

import Foundation
import GraniteUI
import CoreData
import CoreGraphics

extension NSManagedObjectContext {
    public func getStrategy(_ name: String) -> Strategy? {
        let request: NSFetchRequest = StrategyObject.fetchRequest()
        request.predicate = NSPredicate(format: "(name == %@)",
                                        name)
        
        let result: Strategy? = self.performAndWaitPlease { [weak self] in
            do {
                if let object = try self?.fetch(request).first {
                    return object.asStrategy
                } else {
                    return nil
                }
            } catch let error {
                GraniteLogger.info("failed to get strategy \(error)", .utility, focus: true)
                return nil
            }
        }
        
        return result
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
                
                //Get the quotes from the securities requested for adding
                let quoteRequest: NSFetchRequest = QuoteObject.fetchRequest()
                let quoteObjects = try moc.fetch(quoteRequest)
                
                //Get quotes currently cached along with securities about
                //to be added
                var quotes = quoteObjects.filter( { quote in securities.filter({ quote.contains(security: $0) }).isNotEmpty } )
                
                //Check if there are quotes missing from the securities that were not
                //cached yet
                let quotesMissing = securities.filter( { sec in quotes.filter({ $0.contains(security: sec) }).isEmpty } )
                
                //If there were quotes missing, we will create a quote with
                //the security as a placeholder until a valid quote
                //is available to update the strategy with
                //
                //This is a "Lazy nature" of data aggregation required
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
                
                //Converts the securities added into investment objects
                let investments: Strategy.Investments = .init(items: securities.map { $0.asInvestmentItem })
                
                //We will either detect an existing strategy to add them to
                //or simply create a new one
                let strategyToModify: StrategyObject
                if let strategy = object?.strategies?.first {
                    strategyToModify = strategy
                    
                    if let oldInvestments = strategy.investmentData?.investments {
                        
                        //Append existing investments if an existing strategy was found
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
                
                //Link strategy's portfolio relationship to the user's
                strategyToModify.portfolio = object
                
                //quote clean up and updation
                for quote in quotes {
                    strategyToModify.removeFromQuotes(quote)
                    strategyToModify.addToQuotes(quote)
                    
                    //Link the strategy to the quote's found
                    quote.strategy = strategyToModify
                }
                
                //clean up portfolio by resetting via a remove and add
                object?.removeFromStrategies(strategyToModify)
                object?.addToStrategies(strategyToModify)
                
                //save
                try moc.save()
                
                return object?.asPortfolio
            } catch let error {
                return nil
            }
        }
        
        return result
    }
}

extension Strategy {
    public func updated(moc: NSManagedObjectContext) -> Strategy? {
        moc.getStrategy(self.name)
    }
}

extension StrategyObject {
    var asStrategy: Strategy {
        .init(self.quotes?.compactMap { $0.asQuote } ?? [],
              self.name,
              self.date,
              self.investmentData?.investments ?? .empty)
    }
}


