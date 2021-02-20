//
//  Strategy.Investments.Item.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation
import SwiftUI

extension Strategy.Investments.Item {
    public var closedAmount: Double {
        (closedChange ?? latestChange).amount
    }
    
    public var closedPercent: Double {
        ((closedChange ?? latestChange).amount - initial.amount) / initial.amount
    }
    
    public var closedDate: Date {
        (closedChange ?? latestChange).date
    }
    
    public var closedStatusColor: Color {
        closedAmount > initial.amount ? Brand.Colors.green : (latestChange.amount == initial.amount ? Brand.Colors.grey : Brand.Colors.red)
    }
    
    public var lastValue: Double {
        latestChange.amount
    }
    
    public var latestChangePercent: Double {
        (latestChange.amount - initial.amount) / initial.amount
    }
    
    public var statusColor: Color {
        latestChange.amount > initial.amount ? Brand.Colors.green : (latestChange.amount == initial.amount ? Brand.Colors.grey : Brand.Colors.red)
    }
    
    public var tonalTargetDate: Date {
        Date.nextTradingDay.simple
    }
    
    public var tonalSummary: String {
        if let prediction = self.prediction {
            return prediction.asTone.summary
        } else {
            return "no model"
        }
    }
    
    public var tonalAccuracy: String {
        if let prediction = self.prediction {
            return "acc: "+prediction.asTone.accuracy.percent
        } else {
            return "unavailable"
        }
    }
}
