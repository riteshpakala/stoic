//
//  StockSentimentData.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public class StockSentimentData: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let date: Date
    let dateAsString: String
    let stockDateRefAsString: String
    var dateComponents: (year: Int, month: Int, day: Int) {
        date.dateComponents()
    }
    var sentimentData: [VaderSentimentOutput]
    var positives: [Double] {
        return sentimentData.map { $0.pos }
    }
    var neutrals: [Double] {
        return sentimentData.map { $0.neu }
    }
    var negatives: [Double] {
        return sentimentData.map { $0.neg }
    }
    var compounds: [Double] {
        return sentimentData.map { $0.compound }
    }
    let tweetData: [Tweet]
    
    var posAverage: Double {
        guard !positives.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in positives {
            sum += value
        }
        
        return sum/Double(positives.count)
    }
    
    var negAverage: Double {
        guard !negatives.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in negatives {
            sum += value
        }
        
        return sum/Double(negatives.count)
    }
    
    var neuAverage: Double {
        guard !neutrals.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in neutrals {
            sum += value
        }
        
        return sum/Double(neutrals.count)
    }
    
    var compoundAverage: Double {
        guard !compounds.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in compounds {
            sum += value
        }
        
        return sum/Double(compounds.count)
    }
    
    public init(
        date: Date,
        dateAsString: String,
        stockDateRefAsString: String,
        sentimentData: [VaderSentimentOutput],
        tweetData: [Tweet]) {
        
        self.date = date
        self.dateAsString = dateAsString
        self.stockDateRefAsString = stockDateRefAsString
        self.sentimentData = sentimentData
        self.tweetData = tweetData
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DTOKeys.self)
        
        let dataEncoded = try container.decode([String: Any].self, forKey: .sentimentData)
        
        self.sentimentData = dataEncoded.decode().compactMap({ item in VaderSentimentOutput.initialize(from: item) })
        
        self.date = Date()
        self.dateAsString = ""
        self.stockDateRefAsString = ""
        self.tweetData = []
    }
    
    public required convenience init?(coder: NSCoder) {
        let date: Date = (coder.decodeObject(forKey: DTOKeys.date.rawValue) as? Date) ?? .init()
        let dateAsString: String = (coder.decodeObject(forKey: DTOKeys.dateAsString.rawValue) as? String) ?? ""
        let stockDateRefAsString: String = (coder.decodeObject(forKey: DTOKeys.stockDateRefAsString.rawValue) as? String) ?? ""
        let sentimentData: [VaderSentimentOutput] = (coder.decodeObject(forKey: DTOKeys.sentimentData.rawValue) as? [VaderSentimentOutput]) ?? []
        let tweetData: [Tweet] = (coder.decodeObject(forKey: DTOKeys.tweetData.rawValue) as? [Tweet]) ?? []

        self.init(
            date: date,
            dateAsString: dateAsString,
            stockDateRefAsString: stockDateRefAsString,
            sentimentData: sentimentData,
            tweetData: tweetData)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: DTOKeys.date.rawValue)
        coder.encode(dateAsString, forKey: DTOKeys.dateAsString.rawValue)
        coder.encode(stockDateRefAsString, forKey: DTOKeys.stockDateRefAsString.rawValue)
        coder.encode(sentimentData, forKey: DTOKeys.sentimentData.rawValue)
        coder.encode(tweetData, forKey: DTOKeys.tweetData.rawValue)
    }
    
    enum DTOKeys: String, CodingKey {
        case date
        case dateAsString
        case stockDateRefAsString
        case sentimentData
        case tweetData
        case time
    }
    
    public var toString: String {
        let desc: String =
            """
            '''''''''''''''''''''''''''''
            posAverage: \(posAverage)
            negAverage: \(negAverage)
            neuAverage: \(neuAverage)
            compoundAverage: \(compoundAverage)
            '''''''''''''''''''''''''''''
            """
        return desc
    }
    
    public static func emptyWithValues(
        positive: Double,
        negative: Double,
        neutral: Double,
        compound: Double) -> StockSentimentData {
        
        return .init(
            date: .init(),
            dateAsString: "",
            stockDateRefAsString: "",
            sentimentData: [.init(
                pos: positive,
                neg: negative,
                neu: neutral,
                compound: compound)],
            tweetData: [])
    }
    
    public static var zero: StockSentimentData {
        return StockSentimentData.emptyWithValues(
            positive: 0.0,
            negative: 0.0,
            neutral: 0.0,
            compound: 0.0)
    }
    
    public static var neutral: StockSentimentData {
        return StockSentimentData.emptyWithValues(
            positive: 0.25,
            negative: 0.25,
            neutral: 0.5,
            compound: 0.0)
    }
}
