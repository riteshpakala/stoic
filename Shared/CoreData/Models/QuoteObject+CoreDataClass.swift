//
//  SecurityDataObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
//

import GraniteUI
import Foundation
import CoreData


public class QuoteObject: CoreDataManagedObject {
    public typealias Model = StockDataObject
    public static var entityName: String {
        "QuoteObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: QuoteObject.entityName,
            in: context) ?? QuoteObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: QuoteObject.entityName)
    }
}
