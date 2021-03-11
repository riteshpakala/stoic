//
//  Strategy.Investments.Change.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/10/21.
//

import Foundation

extension Strategy.Investments.Item {
    public class Change: Archiveable, Hashable {
        public static func == (lhs: Strategy.Investments.Item.Change, rhs: Strategy.Investments.Item.Change) -> Bool {
            lhs.date == rhs.date
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(date)
        }
        
        /** ** ** **
         *
         * Each change can hold:
         *  - prediction
         *  - modelID
         *
         *  Predictions can be cached.
         *
         *
         
         
         
         */
        
        let amount: Double
        let absoluteChange: Double
        let percentChange: Double
        let date: Date
        
        var modelID: String = ""
        
        var prediction: TonalPrediction? = nil
        var tone: TonalPrediction.Tone = .zero
        
        let isTestable: Bool
        
        public init(_ amount: Double,
                    absoluteChange: Double,
                    percentChange: Double,
                    date: Date = Date.today,
                    isTestable: Bool = false) {
            self.amount = amount
            self.absoluteChange = absoluteChange
            self.percentChange = percentChange
            self.date = date
            self.isTestable = isTestable
        }
        
        // Encoding
        enum CodingKeys: String, CodingKey {
            case amount
            case date
            case absoluteChange
            case percentChange
            case isTestable
            case prediction
            case modelID
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let amount: Double = try container.decode(Double.self, forKey: .amount)
            let date: Date = try container.decode(Date.self, forKey: .date)
            let absoluteChange: Double = try container.decode(Double.self, forKey: .absoluteChange)
            let percentChange: Double = try container.decode(Double.self, forKey: .percentChange)
            let isTestable: Bool = try container.decode(Bool.self, forKey: .isTestable)
            let prediction: TonalPrediction? = try? container.decode(TonalPrediction.self, forKey: .prediction)
            let modelID: String = try container.decode(String.self, forKey: .modelID)
            
            self.init(amount,
                      absoluteChange: absoluteChange,
                      percentChange: percentChange,
                      date: date,
                      isTestable: isTestable)
            
            self.prediction = prediction
            self.modelID = modelID
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(amount, forKey: .amount)
            try container.encode(date, forKey: .date)
            try container.encode(absoluteChange, forKey: .absoluteChange)
            try container.encode(percentChange, forKey: .percentChange)
            try container.encode(isTestable, forKey: .isTestable)
            try container.encode(prediction, forKey: .prediction)
            try container.encode(modelID, forKey: .modelID)
        }
        
        public var asString: String {
            """
            amount: \(self.amount)
            date: \(self.date)
            absoluteChange: \(self.absoluteChange)
            percentChange: \(self.percentChange)
            """
        }
    }
}
