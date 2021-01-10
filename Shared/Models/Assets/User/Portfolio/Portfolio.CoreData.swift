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
    
    public func checkExistence(username: String) -> Bool {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        return (try? self.fetch(request)) != nil
    }
}

extension PortfolioObject {
    public static func checkExistence(moc: NSManagedObjectContext, username: String) -> Bool {
        let request: NSFetchRequest = PortfolioObject.fetchRequest()
        request.predicate = NSPredicate(format: "(username == %@)",
                                        username)
        
        return (try? moc.fetch(request)) != nil
    }
}
