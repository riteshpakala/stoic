//
//  Cryptocurrency.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation

public struct CryptoCurrency: Security {
    public var ticker: String
    public var date: Date
    public var last: Double
    public var high: Double
    public var low: Double
    public var volume: Double
    public var changePercent: Double
    public var changeAbsolute: Double
    public var interval: SecurityInterval
    public var exchangeName: String
}

extension CryptoCurrency {
    public var indicator: String {
        "₿"
    }
    
    public var securityType: SecurityType {
        .crypto
    }
    
    public var lastValue: Double {
        last
    }
    
    public var highValue: Double {
        high
    }
    
    public var lowValue: Double {
        low
    }
    
    public var volumeValue: Double {
        volume
    }
    
    public var changePercentValue: Double {
        changePercent
    }
    
    public var changeAbsoluteValue: Double {
        changeAbsolute
    }
}
