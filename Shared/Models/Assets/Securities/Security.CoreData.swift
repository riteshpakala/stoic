//
//  Security.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation
import GraniteUI

extension Security {
    public func apply(to security: SecurityObject) {
        security.indicator = indicator
        security.ticker = ticker
        security.securityType = securityType.rawValue
        security.lastValue = lastValue
        security.highValue = highValue
        security.lowValue = lowValue
        security.changePercentValue = changePercentValue
        security.volumeValue = volumeValue
        security.exchangeName = exchangeName
        security.intervalType = interval.rawValue
        security.date = date
    }
    
    public func apply(to quote: QuoteObject) {
        quote.exchangeName = exchangeName
        quote.ticker = ticker
        quote.intervalType = interval.rawValue
        quote.securityType = securityType.rawValue
    }
}
