//
//  StockPredictionObject+CoreDataClass.swift
//  
//
//  Created by Ritesh Pakala on 9/3/20.
//
//

import Foundation
import CoreData


public class StockPredictionObject: NSManagedObject {
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(context moc: NSManagedObjectContext) {
        super.init(entity: StockPredictionObject.entity(), insertInto: moc)
        self.id = UUID().uuidString
    }
}
