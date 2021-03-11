//
//  Strategy.Investments.Item.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation
import SwiftUI

extension Strategy.Investments {
    public class Item: Archiveable, Identifiable, Hashable, Equatable {
        public static func == (lhs: Strategy.Investments.Item, rhs: Strategy.Investments.Item) -> Bool {
            lhs.assetID+lhs.date.asStringWithTime == rhs.assetID+rhs.date.asStringWithTime
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(assetID+date.asStringWithTime)
        }
        
        let ticker: String
        let exchangeName: String
        let companyName: String
        let assetID: String
        
        //Chosen model to represent
        var modelID: String = ""
        
        //Date Added Not to be mistaken for the date of
        //the security
        let date: Date
        //
        
        let initial: Change
        var changes: [Change] = []
        
        //Past, future, model management
        var testable: Testable = .init()
        
        var listChanges: [Change] {
            testable.pastChanges + changes
        }
        
        var latestChange: Change {
            changes.first ?? initial
        }
        
        //This is technically best used with preview rather
        //than the expanded view
        var prediction: TonalPrediction? = nil {
            didSet {
                if let newPrediction = prediction {
                    tone = .init(newPrediction,
                                 context: .purchased)
                }
            }
        }
        var tone: TonalPrediction.Tone = .zero
        var closed: Bool = false
        var closedChange: Change? = nil
        //
        
        public init(security: Security, date: Date = .today) {
            self.ticker = security.ticker
            self.companyName = security.name
            self.exchangeName = security.exchangeName
            self.assetID = security.assetID
            self.initial = security.asChange()
            self.date = date
        }
        
        public init(ticker: String,
                    exchangeName: String,
                    companyName: String,
                    assetID: String,
                    initial: Change,
                    date: Date = .today) {
            self.ticker = ticker
            self.exchangeName = exchangeName
            self.companyName = companyName
            self.assetID = assetID
            self.initial = initial
            self.date = date
        }
        
        public func update(from quote: Quote) {
            //This would handle an update/sync, to push changes
            //to the linked list with a way to manage date values
            //for instance, stocks should be EOD change post sync
            //Crypto could be before Midnight NY timezone.
            
            //Since items are already stored in descending order
            //if there was a removal it should remove the first item.
            
            let date = latestChange.date
            guard let index = quote.securities.firstIndex(where: { $0.date == date }) else {
                return
            }
            
            // index 2, but 5 total securities
            // then we would need to get index 3 and index 4 into the list
            //
            // 5 - 2 = 3, 1 - (3-1) == 1...2
            // 2 + 1 = 3
            // 2 + 2 = 4
            // bingo
            
            let dayDiff = quote.securities.count - index
            
            for i in 1...(dayDiff - 1) {
                guard index + i < quote.securities.count else { continue }
                changes.insert(quote.securities[index + i].asChange(), at: 0)
            }
            //this should update changes...
        }
        
        public static var empty: Strategy.Investments.Item {
            .init(security: EmptySecurity())
        }
        
        // Encoding
        enum CodingKeys: String, CodingKey {
            case ticker
            case exchangeName
            case companyName
            case assetID
            case initial
            case changes
            case closed
            case closedChange
            case dateAdded
            case modelID
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let ticker: String = try container.decode(String.self, forKey: .ticker)
            let exchangeName: String = try container.decode(String.self, forKey: .exchangeName)
            let companyName: String = try container.decode(String.self, forKey: .companyName)
            let assetID: String = try container.decode(String.self, forKey: .assetID)
            let initial: Change = try container.decode(Change.self, forKey: .initial)
            let changes: [Change] = try container.decode([Change].self, forKey: .changes)
            let closed: Bool = (try? container.decode(Bool.self, forKey: .closed)) ?? false
            let closedChange: Change? = try? container.decode(Change.self, forKey: .closedChange)
            let dateAdded: Date = try container.decode(Date.self, forKey: .dateAdded)
            let modelID: String = try container.decode(String.self, forKey: .modelID)
            
            self.init(ticker: ticker,
                      exchangeName: exchangeName,
                      companyName: companyName,
                      assetID: assetID,
                      initial: initial,
                      date: dateAdded)
            
            self.closed = closed
            self.closedChange = closedChange
            self.modelID = modelID
            
            self.changes = changes.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(ticker, forKey: .ticker)
            try container.encode(exchangeName, forKey: .exchangeName)
            try container.encode(companyName, forKey: .companyName)
            try container.encode(assetID, forKey: .assetID)
            try container.encode(initial, forKey: .initial)
            try container.encode(changes, forKey: .changes)
            try container.encode(closed, forKey: .closed)
            try container.encode(closedChange, forKey: .closedChange)
            try container.encode(date, forKey: .dateAdded)
            try container.encode(modelID, forKey: .modelID)
        }
        
        public var asString: String {
            var title = """
            [ Strategy Investment Item ]
            ticker: \(ticker)
            assetID: \(assetID)
            """
            
            title += """
            \n----- initial -----
            \(initial.asString)
            -----
            // changes --------
            """
            
            if changes.isEmpty {
                title += "\n None"
            } else {
                for change in changes {
                    title += """
                    \n\(change.asString)
                    -------
                    """
                }
            }
            
            return title
        }
    }
}
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
