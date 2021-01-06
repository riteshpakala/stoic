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

extension Quote {
    public func isEqual(to quote: Quote) -> Bool {
        return self.ticker == quote.ticker &&
            self.exchangeName == quote.exchangeName &&
            self.securityType == quote.securityType
    }
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.exchangeName == security.exchangeName &&
            self.securityType == security.securityType &&
            self.intervalType == security.interval
    }
}
