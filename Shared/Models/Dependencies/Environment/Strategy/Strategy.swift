//
//  Strategy.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/15/21.
//

import Foundation
import CoreGraphics
import GraniteUI

public class StrategyDependency: GraniteDependable {
    var strategy: Strategy = .init([], "", .today, .empty)
}

public class Strategy: Hashable, Identifiable {
    public var id: ObjectIdentifier {
        .init(investments)
    }
    
    public static func == (lhs: Strategy, rhs: Strategy) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var quotes: [Quote]
    var name: String
    var date: Date
    var investments: Strategy.Investments
    
    var endDate: Date {
        var candidate = date.advanceDate(value: 12)
        
        for _ in 0..<12 {
            if candidate.validTradingDay {
                break
            } else {
                candidate = candidate.advanceDate(value: 1)
            }
        }
        
        return candidate
    }
    
    var isValid: Bool {
        return endDate.compare(Date.today) == .orderedDescending
    }
    
    public init(_ quotes: [Quote],
                _ name: String,
                _ date: Date,
                _ investmentData: Strategy.Investments) {
        self.quotes = quotes
        self.name = name
        self.date = date
        self.investments = investmentData
        
        //Update investments
        for quote in quotes {
            if let index = investments.items.firstIndex(where: { $0.assetID == quote.latestSecurity.assetID }) {
                
                let item = investments.items[index]
                
                item.changes.removeAll(where: { $0.date.simple.asString == quote.latestSecurity.date.simple.asString })
                
                //Since items are already stored in descending order
                //if there was a removal it should remove the first item.
                item.changes.insert(.init(quote.latestSecurity.lastValue,
                                           quote.latestSecurity.date), at: 0)
                
                
                self.investments.items[index].changes = item.changes
            }
        }
    }
}

extension Data {
    public var investments: Strategy.Investments? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode(Strategy.Investments.self, from: self)
        } catch let error {
            GraniteLogger.error("core data failed to decode investments\n\(error.localizedDescription)", .utility)
        }
        
        return nil
    }
}
