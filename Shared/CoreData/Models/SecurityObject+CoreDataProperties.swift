//
//  SecurityObject+CoreDataProperties.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/23/20.
//
//

import Foundation
import CoreData


extension SecurityObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecurityObject> {
        return NSFetchRequest<SecurityObject>(entityName: "SecurityObject")
    }

    @NSManaged public var ticker: String
    @NSManaged public var exchangeName: String
    @NSManaged public var intervalType: String
    @NSManaged public var securityType: Int64
    @NSManaged public var indicator: String
    @NSManaged public var lastValue: Double
    @NSManaged public var highValue: Double
    @NSManaged public var lowValue: Double
    @NSManaged public var changePercentValue: Double
    @NSManaged public var changeAbsoluteValue: Double
    @NSManaged public var volumeValue: Double
    @NSManaged public var date: Date

}

extension SecurityObject : Identifiable {

}
