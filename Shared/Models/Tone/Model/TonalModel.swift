//
//  TonalModel.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//

import Foundation
import CoreData
import GraniteUI

public class TonalModel: Asset {
    var date: Date {
        david.created
    }
    
    var targetDate: Date {
        return date.advanceDate(value: 1)
        
        //TODO: Generally we would like daily models
        //but for now all will be 24 hours
        //as well as crypto
        /* switch latestSecurity.interval {
        case .day:
            return date.advanceDate(value: 1)
        case .hour:
            return date.advanceDateHourly(value: 1)
        } */
    }
    
    let daysTrained: Int
    let david: TonalModels
    let tuners: [SentimentOutput]
    let range: [Date]
    private(set) var quote: Quote
    let modelID: String
    var latestSecurity: Security
    var last12Securities: [Security]
    var last12SecuritiesDailies: [Security] = []
    let isStrategy: Bool
    
    public init(_ david: TonalModels,
                daysTrained: Int,
                tuners: [SentimentOutput],
                quote: Quote,
                range: [Date],
                id: String = UUID().uuidString,
                isStrategy: Bool){
        self.david = david
        self.daysTrained = daysTrained
        self.tuners = tuners
        self.quote = quote
        self.range = range
        self.modelID = id
        let sorted = quote.securities.sortDesc
        self.last12Securities = Array(sorted.prefix(12))
        self.latestSecurity = last12Securities.first ?? EmptySecurity.init()
        self.isStrategy = isStrategy
    }
    
    var needsUpdate: Bool {
        Date.today.compare(self.targetDate) == .orderedDescending
    }
    
    public func precompute() {
        self.quote.precompute()
        let sorted = quote.precomputedDailies?.sortDesc ?? self.last12Securities
        self.last12SecuritiesDailies = Array(sorted.prefix(12))
    }
    
    public func predictAll(_ sentiment: SentimentOutput? = nil) -> TonalPrediction {
        let sentimentToUse = sentiment ?? david.sentimentAvg
        
        let close: Double = predict(sentimentToUse, modelType: .close)
        let low: Double = predict(sentimentToUse, modelType: .low)
        let high: Double = predict(sentimentToUse, modelType: .high)
        let volume: Double = predict(sentimentToUse, modelType: .volume)
        
        let prediction: TonalPrediction = .init(close: close,
                                                low: low,
                                                high: high,
                                                volume: volume,
                                                current: latestSecurity.lastValue,
                                                modelDate: date,
                                                targetDate: targetDate,
                                                securityDate: latestSecurity.date,
                                                interval: latestSecurity.interval)
        return prediction
    }
    
    public func predict(_ sentiment: SentimentOutput = .neutral,
                        modelType: TonalModels.ModelType = .close,
                        scale: Bool = true) -> Double {
        quote.precompute()
        guard let output = david.predict(quote,
                                         modelType,
                                         range: self.range,
                                         sentiment: sentiment) else {
            return 0.0
        }
        
        if scale {
            switch modelType {
            case .close:
                return david.scale(prediction: output, latestSecurity.lastValue)
            case .high:
                return david.scale(prediction: output, latestSecurity.highValue)
            case .low:
                return david.scale(prediction: output, latestSecurity.lowValue)
            case .volume:
                return david.scale(prediction: output, latestSecurity.volumeValue)
            default:
                return output
            }
        } else {
            return output
        }
    }
    
    func predict(days: Int,
                 sentiment: SentimentOutput = .neutral,
                 modelType: TonalModels.ModelType = .close) {
        quote.precompute()
        
        var quoteToModify = quote
        let modelToModify = david
        var rangeToModify = range
        
        for i in 0..<days {
            let nextSecurity = quoteToModify.securities.sortDesc.first ?? latestSecurity
            
            var closePercent: Double = 0.0
            var highPercent: Double = 0.0
            var lowPercent: Double = 0.0
            var volume: Double = 0.0
            
            let sentimentRand: SentimentOutput = .init(pos: 0.1.randomBetween(0.2),
                                                   neg: 0.0.randomBetween(0.1),
                                                   neu: 0.2.randomBetween(0.8), compound: 0.0)
            for aModelType in TonalModels.ModelType.allCases {
                guard aModelType != .none else { continue }
                guard let output = modelToModify.predict(quoteToModify,
                                                 aModelType,
                                                 range: rangeToModify,
                                                 sentiment: sentimentRand) else {
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
                default:
                    continue
                }
            }
            
            var securityToAdd = EmptySecurity.init()
            
            let detail: String =
                """
                [Security - \(securityToAdd.date.advanceDate(value: i))]
                close: \(david.scale(prediction: closePercent, nextSecurity.lastValue))
                high: \(david.scale(prediction: highPercent, nextSecurity.highValue))
                low: \(david.scale(prediction: lowPercent, nextSecurity.lowValue))
                volume: \(david.scale(prediction: volume, nextSecurity.volumeValue))
                """
            
            GraniteLogger.info(detail, .utility, focus: true)
            
            securityToAdd.date = securityToAdd.date.advanceDate(value: i)
            securityToAdd.lastValue = david.scale(prediction: closePercent, nextSecurity.lastValue)
            securityToAdd.highValue = david.scale(prediction: highPercent, nextSecurity.highValue)
            securityToAdd.lowValue = david.scale(prediction: lowPercent, nextSecurity.lowValue)
            securityToAdd.volumeValue = david.scale(prediction: volume, nextSecurity.volumeValue)

            quoteToModify.securities.append(securityToAdd)

            rangeToModify.insert(securityToAdd.date, at: 0)

            modelToModify.append(security: securityToAdd,
                                         quote: quoteToModify,
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
                           light: Bool = false) -> [TonalModel] {
       
        let tonalObjects = moc.getTones()
        return tonalObjects.compactMap { light ? $0.asToneLight : $0.asTone }
    }
    
    public static func get(forSecurity security: Security?,
                           light: Bool = false,
                           moc: NSManagedObjectContext) -> [TonalModel] {
        
        guard let security = security else {
            return TonalModel.get(moc: moc, light: light)
        }
        
        let tonalObjects = moc.getTones(forSecurity: security)
        return tonalObjects.compactMap { light ? $0.asToneLight : $0.asTone }
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
