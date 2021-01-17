//
//  CryptoCurrency.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//

import Foundation
import CoreData
import GraniteUI

extension CryptoCurrency {
    public func apply(to security: CryptoDataObject) {
        security.indicator = indicator
        security.ticker = ticker
        security.securityType = securityType.rawValue
        security.lastValue = lastValue
        security.highValue = highValue
        security.lowValue = lowValue
        security.changePercentValue = changePercentValue
        security.changeAbsoluteValue = changeAbsoluteValue
        security.volumeBTC = volumeBTC
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
        security.isStrategy = isStrategy
    }
}

extension Array where Element == CryptoCurrency {
    func save(moc: NSManagedObjectContext, completion: @escaping ((Quote?) -> Void)) {
        guard let referenceCoin = self.first else { completion(nil); return }
        moc.performAndWait {
            do {
                let quotes: [QuoteObject] = try moc.fetch(QuoteObject.fetchRequest())
                
                let quote: QuoteObject = quotes.first(where: { $0.contains(security: referenceCoin) }) ?? QuoteObject.init(context: moc)
                
                referenceCoin.apply(to: quote)
                
                for coin in self {
                    let object = CryptoDataObject.init(context: moc)
                    coin.apply(to: object)
                    object.quote = quote
                    quote.addToSecurities(object)
                }
                
                try moc.save()
                GraniteLogger.info("crypto (array) saved into coreData",
                                   .utility)
                completion(quote.asQuote)
            } catch let error {
                GraniteLogger.error("crypto (array) failed to save into coreData \(error.localizedDescription)",
                                    .utility)
                completion(nil)
            }
        }
    }
}
