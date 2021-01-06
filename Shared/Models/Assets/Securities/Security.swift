//
//  Security.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation

public enum SecurityType: Int64 {
    case crypto
    case stock
    case unassigned
}

public enum SecurityInterval: String {
    case day = "1d"
    case hour = "1h"
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
    
    var exchangeName: String { get set }
    
    var volumeValue: Double { get }
    
    var isGainer: Bool { get }
    
    var interval: SecurityInterval { get set }
}

extension Security {
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
    
    public func isEqual(to security: Security) -> Bool {
        return self.date == security.date &&
            self.ticker == security.ticker &&
            self.exchangeName == security.exchangeName
    }
}

public struct SecurityCharacteristics {

}

public struct EmptySecurity: Security {
    public var date: Date = Date.today
    
    public var indicator: String = "?"
    public var ticker: String = "?"
    
    public var securityType: SecurityType {
        .stock
    }
    
    public var lastValue: Double = 0.0
    public var highValue: Double = 0.0
    public var lowValue: Double = 0.0
    
    public var volumeValue: Double = 0.0
    
    public var changePercentValue: Double { 0.0 }
    public var changeAbsoluteValue: Double { 0.0 }
    
    public var interval: SecurityInterval = .day
    
    public var exchangeName: String = "?"
}
