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
    
    public func changePercent(_ change: Change) -> Double {
        let date = change.date
        if let index = self.listChanges.firstIndex(where: { $0.date == date }),
           index - 1 >= 0 {
            let initial =  self.listChanges[index - 1]
            return (change.amount - initial.amount) /  initial.amount
        } else {
            return 0.0
        }
    }
    
    public var tonalGoal: String {
        if self.prediction != nil {
            return self.tone.goal
        } else {
            return "*\n* train"
        }
    }
    
    public var tonalSummary: String {
        if self.prediction != nil {
            return self.tone.summary
        } else {
            return "no model"
        }
    }
    
    public var tonalDetail: String {
        if self.prediction != nil {
            return self.tone.detail
        } else {
            return "unavailable"
        }
    }
    
    //TODO: this counter needs to work with all intervals
    //of securities
    public var timer: GraniteTimerComponent {
        if let prediction = self.prediction {
            
            return .init(state: .init(initial: prediction.modelDate,
                                      type: .countdown,
                                      limit: prediction.modelDate.secondsFrom(self.tone.targetDate),
                                      style: .minimal))
        } else {
            return GraniteTimerComponent(state: .init(empty: true))
        }
    }
}
