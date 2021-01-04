//
//  SentimentObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//
//

import Foundation
import CoreData


extension SentimentObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SentimentObject> {
        return NSFetchRequest<SentimentObject>(entityName: "SentimentObject")
    }

    @NSManaged public var sentimentType: Int64
    @NSManaged public var pos: Double
    @NSManaged public var neg: Double
    @NSManaged public var neu: Double
    @NSManaged public var content: String
    @NSManaged public var compound: Double
    @NSManaged public var date: Date
    @NSManaged public var security: SecurityObject?

}

extension SentimentObject : Identifiable {

}
