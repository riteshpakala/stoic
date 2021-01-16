//
//  SecurityObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//
//

import Foundation
import CoreData


extension SecurityObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecurityObject> {
        return NSFetchRequest<SecurityObject>(entityName: "SecurityObject")
    }

    @NSManaged public var changeAbsoluteValue: Double
    @NSManaged public var changePercentValue: Double
    @NSManaged public var date: Date
    @NSManaged public var exchangeName: String
    @NSManaged public var highValue: Double
    @NSManaged public var indicator: String
    @NSManaged public var intervalType: String
    @NSManaged public var lastValue: Double
    @NSManaged public var lowValue: Double
    @NSManaged public var name: String
    @NSManaged public var securityType: String
    @NSManaged public var ticker: String
    @NSManaged public var volumeValue: Double
    @NSManaged public var isStrategy: Bool
    @NSManaged public var floor: FloorObject?
    @NSManaged public var portfolio: PortfolioObject?
    @NSManaged public var quote: QuoteObject?
    @NSManaged public var sentiment: Set<SentimentObject>?
    @NSManaged public var strategy: StrategyObject?

}

// MARK: Generated accessors for sentiment
extension SecurityObject {

    @objc(addSentimentObject:)
    @NSManaged public func addToSentiment(_ value: SentimentObject)

    @objc(removeSentimentObject:)
    @NSManaged public func removeFromSentiment(_ value: SentimentObject)

    @objc(addSentiment:)
    @NSManaged public func addToSentiment(_ values: NSSet)

    @objc(removeSentiment:)
    @NSManaged public func removeFromSentiment(_ values: NSSet)

}

extension SecurityObject : Identifiable {

}
