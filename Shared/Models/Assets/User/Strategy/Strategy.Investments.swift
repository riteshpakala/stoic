//
//  Strategy.Investments.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation
import CoreGraphics
import GraniteUI
import SwiftUI

extension Strategy {
    public class Investments: Archiveable {
        public class Item: Archiveable, Identifiable, Hashable, Equatable {
            public static func == (lhs: Strategy.Investments.Item, rhs: Strategy.Investments.Item) -> Bool {
                lhs.assetID+lhs.date.asStringWithTime == rhs.assetID+rhs.date.asStringWithTime
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(assetID+date.asStringWithTime)
            }
            
            public class Change: Archiveable {
                let amount: Double
                let date: Date
                
                public init(_ amount: Double,
                            _ date: Date = Date.today) {
                    self.amount = amount
                    self.date = date
                }
                
                enum CodingKeys: String, CodingKey {
                    case amount
                    case date
                }
                
                required public convenience init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    
                    let amount: Double = try container.decode(Double.self, forKey: .amount)
                    let date: Date = try container.decode(Date.self, forKey: .date)
                    
                    self.init(amount, date)
                }
                
                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    
                    try container.encode(amount, forKey: .amount)
                    try container.encode(date, forKey: .date)
                }
                
                public var asString: String {
                    """
                    amount: \(self.amount)
                    date: \(self.date)
                    """
                }
            }
            
            let ticker: String
            let exchangeName: String
            let companyName: String
            let assetID: String
            
            //Date Added Not to be mistaken for the date of
            //the security
            let date: Date
            //
            
            let initial: Change
            var changes: [Change] = []
            var latestChange: Change {
                changes.first ?? initial
            }
            
            var prediction: TonalPrediction? = nil
            var closed: Bool = false
            var closedChange: Change? = nil
            
            public init(security: Security, date: Date = .today) {
                self.ticker = security.ticker
                self.companyName = security.name
                self.exchangeName = security.exchangeName
                self.assetID = security.assetID
                self.initial = .init(security.lastValue, security.date)
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
            
            public static var empty: Strategy.Investments.Item {
                .init(security: EmptySecurity())
            }
            
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
                
                self.init(ticker: ticker,
                          exchangeName: exchangeName,
                          companyName: companyName,
                          assetID: assetID,
                          initial: initial,
                          date: dateAdded)
                
                self.closed = closed
                self.closedChange = closedChange
                
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
        
        var items: [Item]
        
        public init(items: [Item] = []) {
            self.items = items
        }
        
        enum CodingKeys: String, CodingKey {
            case items
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let items: [Item] = try container.decode([Item].self, forKey: .items)
            
            self.init(items: items)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(items, forKey: .items)
        }
        
        public static var empty: Strategy.Investments {
            .init()
        }
    }
    
    public static var empty: Strategy {
        .init([], "", .today, .empty)
    }
}
