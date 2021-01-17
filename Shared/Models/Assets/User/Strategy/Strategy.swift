//
//  Strategy.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/15/21.
//

import Foundation
import CoreGraphics
import GraniteUI

public struct Strategy: Hashable, Identifiable {
    public var id: ObjectIdentifier {
        .init(investmentData)
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
    var investmentData: Strategy.Investments
    
    public init(_ quotes: [Quote],
                _ name: String,
                _ date: Date,
                _ investmentData: Strategy.Investments) {
        self.quotes = quotes
        self.name = name
        self.date = date
        self.investmentData = investmentData
    }
    
    public class Investments: Archiveable {
        let assetID: String
        let amount: Double
        let date: Date
        
        public init(assetID: String,
                    amount: Double,
                    date: Date = Date.today) {
            self.assetID = assetID
            self.amount = amount
            self.date = date
            super.init()
        }
        
        enum CodingKeys: String, CodingKey {
            case assetID
            case amount
            case date
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let assetID: String = try container.decode(String.self, forKey: .assetID)
            let amount: Double = try container.decode(Double.self, forKey: .amount)
            let date: Date = try container.decode(Date.self, forKey: .date)
            
            self.init(assetID: assetID,
                      amount: amount,
                      date: date)
        }
        
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(assetID, forKey: .assetID)
            try container.encode(amount, forKey: .amount)
            try container.encode(date, forKey: .date)
        }
        
        public static var empty: Strategy.Investments {
            .init(assetID: "", amount: .zero)
        }
    }
    
    public static var empty: Strategy {
        .init([], "", .today, .empty)
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
