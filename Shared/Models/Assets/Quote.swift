//
//  Quote.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//


import Foundation
import GraniteUI

public struct Quote {
    var ticker: String
    var securityType: SecurityType
    var exchangeName: String
    var name: String
    var securities: [Security]
    
    var latestSecurity: Security {
        securities.sortDesc.first ?? EmptySecurity()
    }
    
    var tickerSymbol: String {
        latestSecurity.symbol
    }
    
    var latestChangePercent: Double {
        latestSecurity.changePercentValue
    }
    
    var latestChangeAbsolute: Double {
        latestSecurity.changeAbsoluteValue
    }
    
    var latestIsGainer: Bool {
        latestSecurity.isGainer
    }
    
    var latestValue: Double {
        latestSecurity.lastValue
    }
    
    public var quoteID: String {
        ticker+name
    }
    
    var needsUpdate: Bool {
        let days: Int = Date.today.daysFrom(latestSecurity.date)
        
        return abs(days) > 0 || securities.count < 4
    }
}

extension Quote {
    public func isEqual(to quote: Quote) -> Bool {
        return self.ticker == quote.ticker &&
            self.exchangeName == quote.exchangeName &&
            self.securityType == quote.securityType
    }
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.name == security.name &&
            self.securityType == security.securityType
    }
}

extension Quote {
    func intraday(count: Int = 120) -> [Security] {
        let securities = self.securities.sortDesc
        return Array(securities.prefix(count))
    }
    
    func daily(count: Int = 120) -> [Security] {
        let securities = self.securities.sortDesc
        return Array(securities.prefix(count))
    }
}
