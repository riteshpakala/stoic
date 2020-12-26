//
//  SecurityDataObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
//

import Foundation
import CoreData
import GraniteUI

extension QuoteObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuoteObject> {
        return NSFetchRequest<QuoteObject>(entityName: "QuoteObject")
    }

    @NSManaged public var intervalType: String
    @NSManaged public var ticker: String
    @NSManaged public var securityType: Int64
    @NSManaged public var exchangeName: String
    @NSManaged public var securities: Set<SecurityObject>

}

// MARK: Generated accessors for securities
extension QuoteObject {

    @objc(addSecuritiesObject:)
    @NSManaged public func addToSecurities(_ value: SecurityObject)

    @objc(removeSecuritiesObject:)
    @NSManaged public func removeFromSecurities(_ value: SecurityObject)

    @objc(addSecurities:)
    @NSManaged public func addToSecurities(_ values: NSSet)

    @objc(removeSecurities:)
    @NSManaged public func removeFromSecurities(_ values: NSSet)

}

extension QuoteObject : Identifiable {

}
