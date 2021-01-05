//
//  Quote.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

public struct Quote {
    var intervalType: SecurityInterval
    var ticker: String
    var securityType: SecurityType
    var exchangeName: String
    var securities: [Security]
}

extension QuoteObject {
    public var asQuote: Quote {
        .init(intervalType: SecurityInterval(rawValue: self.intervalType) ?? .day,
              ticker: self.ticker,
              securityType: SecurityType(rawValue: self.securityType) ?? .unassigned,
              exchangeName: self.exchangeName,
              securities: self.securities.compactMap { $0.asSecurity })
    }
}
