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
    public func getUser(_ username: String) -> PortfolioObject? {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        return (try? self.fetch(request))?.first
    }
    
    public func pullPortfolios() -> [PortfolioObject]? {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        return (try? self.fetch(request))
    }
    
    public func getPortfolioObject(username: String) -> PortfolioObject? {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        let objects = (try? self.fetch(request))
        if let port = objects?.first {
            return port
        } else {
            return nil
        }
    }
    
    public func getPortfolio(username: String) -> Portfolio? {
        return self.getPortfolioObject(username: username)?.asPortfolio
    }
}

extension PortfolioObject {
    public var asPortfolio: Portfolio {
        return .init(self.username,
                     .init(securities: Array(self.securities ?? .init()).asSecurities),
                     self.floor?.asFloor ?? .init())
    }
    
    public static func hasSecurity(moc: NSManagedObjectContext, username: String) -> Bool {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        let objects = try? moc.fetch(request)
        
        return objects != nil && objects?.isNotEmpty == true
    }
}
