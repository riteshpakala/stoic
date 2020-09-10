//
//  StockModelObject+CoreDataClass.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData


public class StockModelObject: StockModelParentObject {
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.id = UUID().uuidString
        self.version = "david.v0.00.00"
    }
    
    public init(context moc: NSManagedObjectContext) {
        super.init(entity: StockModelObject.entity(), insertInto: moc)
        self.id = UUID().uuidString
        self.version = "david.v0.00.00"
    }
}
