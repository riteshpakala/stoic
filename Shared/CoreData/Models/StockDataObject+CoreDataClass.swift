//
//  StockObject+CoreDataClass.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/23/20.
//
//

import GraniteUI
import Foundation
import CoreData


public class StockDataObject: SecurityObject, CoreDataManaged {
    public typealias Model = StockDataObject
    public static var entityName: String {
        "StockDataObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: StockDataObject.entityName,
            in: context) ?? StockDataObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: StockDataObject.entityName)
    }
}
