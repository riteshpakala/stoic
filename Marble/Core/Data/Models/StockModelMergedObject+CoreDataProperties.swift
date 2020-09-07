//
//  StockModelMergedObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData


extension StockModelMergedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockModelMergedObject> {
        return NSFetchRequest<StockModelMergedObject>(entityName: "StockModelMergedObject")
    }

    @NSManaged public var models: StockModelObject?

}
