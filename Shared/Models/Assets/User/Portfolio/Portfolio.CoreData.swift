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

extension PortfolioObject {
    public var asPortfolio: Portfolio {
        return .init(self.username,
                     .init(securities: Array(self.securities ?? .init()).asSecurities.sortDesc),
                     self.floor?.compactMap( { $0.asFloor }) ?? [])
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
