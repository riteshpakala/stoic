//
//  TonalModelObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//
//

import Foundation
import CoreData
import GraniteUI

public class TonalModelObject: CoreDataManagedObject {
    public typealias Model = TonalModelObject
    public static var entityName: String {
        "TonalModelObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: TonalModelObject.entityName,
            in: context) ?? TonalModelObject.entity()
        self.init(entity: entity, insertInto: context)
        self.id = UUID().uuidString
        self.engine = TonalModels.engine
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: TonalModelObject.entityName)
    }
}
