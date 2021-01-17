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
    public func pullPortfolios(_ completion: @escaping (([PortfolioObject]?) -> Void)) {
        self.performAndWait {
            completion(try? self.fetch(PortfolioObject.fetchRequest()))
        }
    }
    
    public func getPortfolioObject(_ username: String,
                                   _ completion: @escaping((PortfolioObject?) -> Void)) {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        self.performAndWait {
            completion(try? self.fetch(request).first)
        }
    }
    
    public func getPortfolio(username: String, _ completion: @escaping ((Portfolio?) -> Void)){
        self.getPortfolioObject(username) { object in
            completion(object?.asPortfolio)
        }
    }
}

extension Portfolio {

    func addToStrategy(_ securities: [Security],
                       moc: NSManagedObjectContext,
                       _ completion: @escaping((Portfolio?) -> Void)) {
        
        moc.getPortfolioObject(self.username) { object in
            
            //TODO:
            //Only keeping a single strategy alive for now
            //will open it up later to manage multiple strategies
            //at a time.
            moc.performAndWait {
                let quoteRequest: NSFetchRequest = QuoteObject.fetchRequest()
                guard let quoteObjects = try? moc.fetch(quoteRequest) else { return }
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
                
                let strategyToModify: StrategyObject
                if let strategy = object?.strategies?.first {
                    strategyToModify = strategy
                } else {
                    let strategy = StrategyObject.init(context: moc)
                    strategyToModify = strategy
                    strategyToModify.date = Date.today
                    strategyToModify.name = Date.today.simple.asString
                }
                strategyToModify.portfolio = object
                for quote in quotes {
                    strategyToModify.removeFromQuotes(quote)
                    strategyToModify.addToQuotes(quote)
                    quote.strategy = strategyToModify
                }
                
                object?.removeFromStrategies(strategyToModify)
                object?.addToStrategies(strategyToModify)
                
                try? moc.save()
                
                completion(object?.asPortfolio)
            }
        }
    }
}

extension PortfolioObject {
    public var asPortfolio: Portfolio {
        return .init(self.username,
                     .init(Array(self.securities ?? .init()).asSecurities),
                     self.floor?.compactMap( { $0.asFloor } ) ?? [],
                     self.strategies?.compactMap( { $0.asStrategy }) ?? []
                     )
    }
    
    public static func hasSecurity(moc: NSManagedObjectContext,
                                   username: String,
                                   _ completion: @escaping((Bool) -> Void)) {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        moc.performAndWait {
            let objects = try? moc.fetch(request)
            
            completion(objects != nil && objects?.isNotEmpty == true)
        }
    }
}
