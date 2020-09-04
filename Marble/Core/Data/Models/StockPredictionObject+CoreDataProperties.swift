//
//  StockPredictionObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/3/20.
//
//

import Foundation
import CoreData


extension StockPredictionObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockPredictionObject> {
        return NSFetchRequest<StockPredictionObject>(entityName: "StockPredictionObject")
    }

    @NSManaged public var date: Double
    @NSManaged public var id: String?

}
