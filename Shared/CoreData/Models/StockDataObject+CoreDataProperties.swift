//
//  StockObject+CoreDataProperties.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/23/20.
//
//

import Foundation
import CoreData


extension StockDataObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockDataObject> {
        return NSFetchRequest<StockDataObject>(entityName: "StockDataObject")
    }
    
    @NSManaged public var open: Double
    @NSManaged public var high: Double
    @NSManaged public var low: Double
    @NSManaged public var close: Double
    @NSManaged public var volume: Double
}
