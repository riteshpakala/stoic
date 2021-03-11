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
