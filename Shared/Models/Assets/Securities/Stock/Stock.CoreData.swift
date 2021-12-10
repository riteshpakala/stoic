//
//  Stock.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation
import CoreData
import GraniteUI

extension Stock {
    public func apply(to security: StockDataObject) {
        security.indicator = indicator
        security.ticker = ticker
        security.securityType = securityType.rawValue
        security.lastValue = lastValue
        security.highValue = highValue
        security.lowValue = lowValue
        security.changePercentValue = changePercentValue
        security.changeAbsoluteValue = changeAbsoluteValue
        security.volumeValue = volumeValue
        security.exchangeName = exchangeName
        security.intervalType = interval.rawValue
        security.date = date
        security.open = open
        security.low = low
        security.close = close
        security.high = high
        security.volume = volume
        security.name = name
    }
}

extension Array where Element == Stock {
    func save(moc: NSManagedObjectContext) -> Quote? {
        guard let referenceStock = self.first else { return nil }
        let result: Quote? = moc.performAndWaitPlease {
            do {
                let quotes: [QuoteObject] = try moc.fetch(QuoteObject.fetchRequest())
                
                let quote: QuoteObject = quotes.first(where: { $0.contains(security: referenceStock) }) ?? QuoteObject.init(context: moc)
                
                referenceStock.apply(to: quote)
                
                for stock in self {
                    let object = StockDataObject.init(context: moc)
                    stock.apply(to: object)
                    object.quote = quote
                    quote.addToSecurities(object)
                }
                
                try moc.save()
                
                GraniteLogger.info("stocks (array) saved into coreData",
                                   .utility)
                return quote.asQuote
            } catch let error {
                GraniteLogger.error("stocks (array) failed to save into coreData \(error.localizedDescription)",
                                    .utility)
                return nil
            }
        }
        return result
    }
}
