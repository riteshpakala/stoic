//
//  TonalModel.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//

import Foundation
import CoreData

public struct TonalModel: Asset {
    let date: Date
    let daysTrained: Int
    let david: TonalModels
    let tuners: [SentimentOutput]
    let range: [Date]
    let quote: Quote
    let id: String
    
    var latestSecurity: Security {
        quote.securities.sortDesc.first ?? EmptySecurity()
    }
    
    public init(_ david: TonalModels,
                daysTrained: Int,
                tuners: [SentimentOutput],
                quote: Quote,
                range: [Date],
                date: Date = Date.today,
                id: String = UUID().uuidString){
        self.david = david
        self.daysTrained = daysTrained
        self.tuners = tuners
        self.quote = quote
        self.range = range
        self.date = date
        self.id = id
    }
    
    public func predict(_ sentiment: SentimentOutput = .neutral) -> Double {
        guard let output = david.predict(quote,
                                         range: self.range,
                                         sentiment: sentiment) else {
            return 0.0
        }
        return david.scale(prediction: output, latestSecurity.lastValue)
    }
}

extension TonalModel {
    public var assetType: AssetType {
        .model
    }
}

extension TonalModel {
    public static func get(moc: NSManagedObjectContext) -> [TonalModel]? {
        guard let toneObjects = moc.getTones(moc: moc) else {
            print("{TEST} model failed 4")
            return nil
        }
        
        return toneObjects.compactMap { $0.asTone }
    }
}

extension Data {
    public var model: TonalModels? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode(TonalModels.self, from: self)
        } catch let error {
            print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var sentimentTuners: [SentimentOutput]? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode([SentimentOutput].self, from: self)
        } catch let error {
            print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var tonalRange: [Date]? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode([Date].self, from: self)
        } catch let error {
            print("{CoreData} \(error)")
        }
        
        return nil
    }
}

extension Array where Element == Date {
    public var archived: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}

extension Array where Element == SentimentOutput {
    public var archived: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}
