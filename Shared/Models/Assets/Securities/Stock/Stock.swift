//
//  Stock.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation

public struct Stock: Security {
    public var ticker: String
    public var date: Date
    public var open: Double
    public var high: Double
    public var low: Double
    public var close: Double
    public var volume: Double
    public var changePercent: Double
    public var changeAbsolute: Double
}

extension Stock {
    public var indicator: String {
        "$"
    }
    
    public var securityType: SecurityType {
        .stock
    }
    
    public var lastValue: Double {
        close
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
