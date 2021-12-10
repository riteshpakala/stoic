//
//  FloorObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//
//

import Foundation
import CoreData


extension FloorObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FloorObject> {
        return NSFetchRequest<FloorObject>(entityName: "FloorObject")
    }

    @NSManaged public var coordX: Int32
    @NSManaged public var coordY: Int32
    @NSManaged public var portfolio: PortfolioObject?
    @NSManaged public var security: SecurityObject?

}

extension FloorObject : Identifiable {

}
