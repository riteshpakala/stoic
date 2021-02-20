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
    var dailySecurities: [Security] {
        precomputedDailies ?? securities.dailies
    }
    var precomputedDailies: [Security]? = nil
    var models: [TonalModel]
    
    public init(ticker: String,
                securityType: SecurityType,
                exchangeName: String,
                name: String,
                securities: [Security],
                models: [TonalModel] = []) {
        self.ticker = ticker
        self.securityType = securityType
        self.exchangeName = exchangeName
        self.name = name
        self.securities = securities
        self.models = models
    }
    
    public mutating func precompute() {
        guard self.precomputedDailies == nil else { return }
        self.precomputedDailies = dailySecurities
    }
    
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
        let hours: Int = Date.today.hoursFrom(latestSecurity.date)
//        let shouldUpdateHour = latestSecurity.date.timeComponents().hour <= Date.today.closingHour && latestSecurity.securityType == .stock
        
//        let isToday: Bool = latestSecurity.date.dateComponents().day <= Date.today.dateComponents().day
        let afterHours: Bool = Date.today.closingHour <= latestSecurity.date.timeComponents().hour && self.securityType == .stock
//        let hourCheck: Int = Date.today.closingHour <= latestSecurity.date.timeComponents().hour ? hours + 1 : 1
        
        return ((abs(days) > 0 || (hours >= 1)) || securities.count < 4) && !afterHours// && Date.today.validTradingDay) || securities.count < 4
    }
    
    var updateTime: Int? {
        let hours: Int = Date.today.hoursFrom(latestSecurity.date)
        let days = max(1, hours/24)
        return securities.count < 4 ? nil : days
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
