//
//  TonalModel.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//

import Foundation
import CoreData
import GraniteUI

public struct TonalModel: Asset {
    let date: Date
    let daysTrained: Int
    let david: TonalModels
    let tuners: [SentimentOutput]
    let range: [Date]
    let quote: Quote
    let modelID: String
    var latestSecurity: Security
    
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
        self.modelID = id
        self.latestSecurity = quote.securities.sortDesc.first ?? EmptySecurity()
    }
    
    public func predict(_ sentiment: SentimentOutput = .neutral,
                        modelType: TonalModels.ModelType = .close) -> Double {
        guard let output = david.predict(quote,
                                         modelType,
                                         range: self.range,
                                         sentiment: sentiment) else {
            return 0.0
        }
        return output//david.scale(prediction: output, latestSecurity.lastValue)
    }
}

extension TonalModel {
    public var assetType: AssetType {
        .model
    }
    
    public var assetID: String {
        self.modelID
    }
    
    public var idDisplay: String {
        (self.modelID.components(separatedBy: "-").last ?? self.modelID).lowercased()
    }
}

extension TonalModel {
    public static func get(moc: NSManagedObjectContext,
                           _ completion: @escaping (([TonalModel]) -> Void)){
       
        moc.getTones { tonalObjects in
            completion(tonalObjects.compactMap { $0.asTone })
        }
    }
    
    public static func get(forSecurity security: Security?,
                           moc: NSManagedObjectContext,
                           _ completion: @escaping (([TonalModel]) -> Void)) {
        guard let security = security else {
            TonalModel.get(moc: moc, completion)
            return
        }
        
        moc.getTones(forSecurity: security) { tonalObjects in
            completion(tonalObjects.compactMap { $0.asTone })
        }
    }
}

extension Data {
    public var model: TonalModels? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode(TonalModels.self, from: self)
        } catch let error {
            GraniteLogger.error("core data failed to decode tonal model\n\(error.localizedDescription)", .utility)
        }
        
        return nil
    }
    
    public var sentimentTuners: [SentimentOutput]? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode([SentimentOutput].self, from: self)
        } catch let error {
            GraniteLogger.error("core data failed to decode sentimentTuners\n\(error.localizedDescription)", .utility)
        }
        
        return nil
    }
    
    public var tonalRange: [Date]? {
        let jsonDecoder: JSONDecoder = .init()
        do {
            return try jsonDecoder.decode([Date].self, from: self)
        } catch let error {
            GraniteLogger.error("core data failed to decode tonalRange\n\(error.localizedDescription)", .utility)
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
            GraniteLogger.error("core data failed to decode archived date array\n\(error.localizedDescription)", .utility)
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
            GraniteLogger.error("core data failed to decode archived sentiment output array\n\(error.localizedDescription)", .utility)
            return nil
        }
    }
}
