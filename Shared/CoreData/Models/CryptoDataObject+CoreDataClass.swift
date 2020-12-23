//
//  CryptoDataObject+CoreDataClass.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/23/20.
//
//

import Foundation
import CoreData
import GraniteUI

public class CryptoDataObject: SecurityObject, CoreDataManaged {
    public typealias Model = CryptoDataObject
    public static var entityName: String {
        "CryptoDataObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: CryptoDataObject.entityName,
            in: context) ?? CryptoDataObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: CryptoDataObject.entityName)
    }
}
