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
    }
}

extension Array where Element == Stock {
    func save(moc: NSManagedObjectContext, completion: @escaping ((Quote?) -> Void)) {
        guard let referenceStock = self.first else { completion(nil); return }
        moc.performAndWait {
            
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
                
                print ("{CoreData} saved stocks")
                completion(quote.asQuote)
            } catch let error {
                print ("{CoreData} \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
