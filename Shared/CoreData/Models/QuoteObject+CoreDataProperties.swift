//
//  QuoteObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//
//

import Foundation
import CoreData


extension QuoteObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuoteObject> {
        return NSFetchRequest<QuoteObject>(entityName: "QuoteObject")
    }

    @NSManaged public var intervalType: String
    @NSManaged public var ticker: String
    @NSManaged public var securityType: Int64
    @NSManaged public var exchangeName: String
    @NSManaged public var securities: Set<SecurityObject>
    @NSManaged public var tonalModel: Set<TonalModelObject>?

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

// MARK: Generated accessors for tonalModel
extension QuoteObject {

    @objc(addTonalModelObject:)
    @NSManaged public func addToTonalModel(_ value: TonalModelObject)

    @objc(removeTonalModelObject:)
    @NSManaged public func removeFromTonalModel(_ value: TonalModelObject)

    @objc(addTonalModel:)
    @NSManaged public func addToTonalModel(_ values: NSSet)

    @objc(removeTonalModel:)
    @NSManaged public func removeFromTonalModel(_ values: NSSet)

}

extension QuoteObject : Identifiable {

}
