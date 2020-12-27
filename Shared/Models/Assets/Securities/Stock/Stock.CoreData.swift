//
//  Stock.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation
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
