//
//  PortfolioObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//
//

import Foundation
import CoreData


extension PortfolioObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioObject> {
        return NSFetchRequest<PortfolioObject>(entityName: "PortfolioObject")
    } 

    @NSManaged public var username: String?
    @NSManaged public var securities: SecurityObject?

}

extension PortfolioObject : Identifiable {

}
