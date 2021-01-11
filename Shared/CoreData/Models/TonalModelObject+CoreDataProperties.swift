//
//  TonalModelObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//
//

import Foundation
import CoreData


extension TonalModelObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TonalModelObject> {
        return NSFetchRequest<TonalModelObject>(entityName: "TonalModelObject")
    }

    @NSManaged public var id: String
    @NSManaged public var engine: String
    @NSManaged public var date: Date
    @NSManaged public var daysTrained: Int32
    @NSManaged public var sentimentTuners: Data
    @NSManaged public var model: Data
    @NSManaged public var range: Data
    @NSManaged public var quote: QuoteObject?

}

extension TonalModelObject : Identifiable {

}
