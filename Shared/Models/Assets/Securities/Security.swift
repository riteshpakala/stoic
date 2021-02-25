//
//  Security.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import SwiftUI

public enum SecurityType: String {
    case crypto
    case stock
    case unassigned
}

public enum SecurityInterval: String {
    case day = "1d"
    case hour = "1h"
    
    var seconds: Int {
        switch self {
        case .day:
            return 86400
        case .hour:
            return 3600
        }
    }
}

public protocol Security: Asset {
    var date: Date { get set }
    var indicator: String { get }
    var ticker: String { get set }
    var securityType: SecurityType { get }
    var stoicValue: Double { get }
    var predictionValue: Double { get }
    
    var lastValue: Double { get }
    var highValue: Double { get }
    var lowValue: Double { get }
    var changePercentValue: Double { get }
    var changeAbsoluteValue: Double { get }
    
    var name: String { get set }
    
    var exchangeName: String { get set }
    
    var volumeValue: Double { get }
    
    var isGainer: Bool { get }
    
    var interval: SecurityInterval { get set }
    
    var hasStrategy: Bool { get set }
    var hasPortfolio: Bool { get set }
}

extension Security {
    public var display: String {
        indicator+ticker.uppercased()
    }
    
    public var assetID: String {
        ticker+name+interval.rawValue
    }
    
    public var stoicValue: Double {
        0.0
    }
    
    public var predictionValue: Double {
        0.0
    }
    
    public var isGainer: Bool {
        changePercentValue >= 0.0
    }
    
    public var assetType: AssetType {
        .security
    }
    
    public static var empty: Security {
        EmptySecurity.init()
    }
    
    public var prettyChangePercent: Double {
        abs(changePercentValue)
    }
    
    public var sentimentDate: Date {
        self.date.advanced(by: -1)
    }
    
    public var statusColor: Color {
        isGainer ? Brand.Colors.green : Brand.Colors.red
    }
    
    public func isEqual(to security: Security) -> Bool {
        return self.date == security.date &&
            self.ticker == security.ticker &&
            self.exchangeName == security.exchangeName
    }
    
    var updateTime: Int {
        let hours: Int = Date.today.hoursFrom(date)
        let days = max(1, hours/24)
        return days
    }
    
    public var isLatest: Bool {
        !isNotLatest
    }
    
    public var isNotLatest: Bool {
        let days: Int = Date.today.daysFrom(self.date)
        let hours: Int = Date.today.hoursFrom(self.date)
//        let shouldUpdateHour = latestSecurity.date.timeComponents().hour <= Date.today.closingHour && latestSecurity.securityType == .stock
        
//        let isToday: Bool = latestSecurity.date.dateComponents().day <= Date.today.dateComponents().day
        let afterHours: Bool = Date.today.closingHour <= Date.today.timeComponents().hour && self.securityType == .stock
//        let hourCheck: Int = Date.today.closingHour <= latestSecurity.date.timeComponents().hour ? hours + 1 : 1
        
        let daysAreOverdue = abs(days) > 0
        let hoursAreOverdue = hours >= 1 && !afterHours
        
        return (daysAreOverdue || hoursAreOverdue)
    }
}

public struct SecurityCharacteristics {

}

public struct EmptySecurity: Security {
    public var date: Date = Date.today
    
    public var indicator: String = "?"
    public var ticker: String = "?"
    public var name: String = "?"
    
    public var securityType: SecurityType {
        .unassigned
    }
    
    public var lastValue: Double = 0.0
    public var highValue: Double = 0.0
    public var lowValue: Double = 0.0
    
    public var volumeValue: Double = 0.0
    
    public var changePercentValue: Double { 0.0 }
    public var changeAbsoluteValue: Double { 0.0 }
    
    public var interval: SecurityInterval = .day
    
    public var exchangeName: String = "?"
    
    public var hasStrategy: Bool = false
    public var hasPortfolio: Bool = false
}
