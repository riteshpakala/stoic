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
    
    func predict(days: Int,
                 sentiment: SentimentOutput = .neutral,
                 modelType: TonalModels.ModelType = .close) {
        
        var quoteToModify = quote
        var modelToModify = david
        var rangeToModify = range
        
        for i in 0..<days {
            let nextSecurity = quoteToModify.securities.sortDesc.first ?? latestSecurity
            
            var closePercent: Double = 0.0
            var highPercent: Double = 0.0
            var lowPercent: Double = 0.0
            var volume: Double = 0.0
            var stochasticK: Double = 0.0
            var stochasticD: Double = 0.0
            
            for aModelType in TonalModels.ModelType.allCases {
                guard aModelType != .none else { continue }
                guard let output = modelToModify.predict(quoteToModify,
                                                 aModelType,
                                                 range: self.range,
                                                 sentiment: sentiment) else {
                    continue
                }
                
                switch aModelType {
                case .close:
                    closePercent = output
                case .high:
                    highPercent = output
                case .low:
                    lowPercent = output
                case .volume:
                    volume = output
                case .stochasticK:
                    stochasticK = output
                case .stochasticD:
                    stochasticD = output
                default:
                    continue
                }
            }
            
            var securityToAdd = EmptySecurity.init()
            securityToAdd.date = securityToAdd.date.advanceDate(value: i)
            securityToAdd.lastValue = david.scale(prediction: closePercent, nextSecurity.lastValue)
            securityToAdd.highValue = david.scale(prediction: highPercent, nextSecurity.highValue)
            securityToAdd.lowValue = david.scale(prediction: lowPercent, nextSecurity.lowValue)
            securityToAdd.volumeValue = volume
            
            quoteToModify.securities.append(EmptySecurity.init())
            
            rangeToModify.insert(securityToAdd.date, at: 0)
            
            modelToModify = modelToModify.append(security: securityToAdd,
                                                 quote: quote,
                                                 sentiment: sentiment)
        }
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
