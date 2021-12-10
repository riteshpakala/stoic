//
//  SearchResponseObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//
//

import Foundation
import CoreData
import GraniteUI

public class SearchResponseObject: NetworkResponseObject, CoreDataManaged {
    public typealias Model = SearchResponseObject
    public static var entityName: String {
        "SearchResponseObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: SearchResponseObject.entityName,
            in: context) ?? SearchResponseObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: SearchResponseObject.entityName)
    }
}
