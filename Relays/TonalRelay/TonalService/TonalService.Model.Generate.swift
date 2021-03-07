//
//  TonalService.Model.Generate.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/20/21.
//

import Foundation
import GraniteUI
import CoreData

//MARK: -- Generate
extension TonalModels {
    public static func generate(tone: Tone,
                                moc: NSManagedObjectContext,
                                _ completion: @escaping ((TonalModels?) -> Void)) {
        
        guard let range = tone.selectedRange else {
            GraniteLogger.error("failed to retrieve range\nself: \(String(describing: self))", .relay, focus: true)
            completion(nil)
            return
        }
        
        let securityObjects = range.objects
        
        let foundQuote = securityObjects.first?.getQuote(moc: moc)
        guard var quote = foundQuote else {
            GraniteLogger.info("failed to retrieve quote\nself: \(String(describing: self))", .relay, focus: true)
            completion(nil)
            return
        }
        
        quote.precompute()
        
        let securities = securityObjects
        let sentiments = tone.tune.sentiments
        
        let bucket: TonalService.AI.Models.Bucket = .init(sentiments: sentiments, range: range)
        
        // Time-series execution's foundation is that
        // the time comparable is equivalent to the data
        // size
        guard bucket.isValid else {
            GraniteLogger.info("failed to bucket\n\(bucket.pockets.count)\n\(bucket.rangeDates)\nself: \(String(describing: self))", .relay, focus: true)
            return
        }
        
        GraniteLogger.info("generating tonal model", .ml, focus: true, symbol: "🛠")
        
        var sentimentAvgs: [SentimentOutput] = []
        var models: [TonalModels.Model] = []
        for modelType in ModelType.allCases {
            guard modelType != .none else { continue }
            
            GraniteLogger.info("-- working on: \(modelType) --", .ml, focus: true, symbol: "🚧")
            let type: ModelType = modelType
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: type.inDim,
                outputDimension: TonalService.AI.Models.Settings.outDim)
            
            for date in bucket.rangeDates {
                guard let pocket = bucket.pockets.first(where: { $0.date == date }),
                      let security = securities.first(where: { $0.date.simple == date.simple }) else {
                    
                    GraniteLogger.info("-- invalid bucket for security --", .ml, focus: true)
                    continue
                }

                do {
                    let dataSet = TonalService.AI.Models.DataSet(
                        security,
                        pocket.avg,
                        quote: quote,
                        modelType: type)
                    
                    sentimentAvgs.append(pocket.avg)
                    
                    if modelType == .close {
                        GraniteLogger.info("inserting dataSet:\n\(dataSet.description)", .ml, focus: true)
                    }
                    
                    try dataForDavid.addDataPoint(
                        input: dataSet.asArray,
                        output: dataSet.output,
                        label: security.date.asString)
                }
                catch {
                    GraniteLogger.error("invalid dataSet", .ml, focus: true)
                }
            }
    
            let david = SVMModel(
                problemType: .ϵSVMRegression,
                kernelSettings:
                KernelParameters(type: .Polynomial,
                                 degree: 3,
                                 gamma: 0.3,
                                 coef0: 0.0))

            david.Cost = 1e3
            david.train(data: dataForDavid)
            
            models.append(modelType.model(for: david))
            
            GraniteLogger.info("-- completed: \(modelType) ☑️ --", .ml, focus: true, symbol: "🚧")
        }
        
        GraniteLogger.info("tonal model generation - complete - ✅", .ml, focus: true)
        
        completion(.init(models: models, sentiments: sentimentAvgs, created: quote.latestSecurity.date))
    }
    
    public func append(security: Security,
                       quote: Quote,
                       sentiment: SentimentOutput) /*-> TonalModels*/ {
        
//        var modelsToAppend: [Model] = []
        var sentimentAvgs: [SentimentOutput] = self.sentiments
        for type in ModelType.allCases {
            guard let model = self.model(forType: type),
                  let dataForDavid = model.dataSet else {
                continue
            }

            let dataSet: TonalService.AI.Models.DataSet = TonalService.AI.Models.DataSet(
                security,
                sentiment,
                quote: quote,
                modelType: type)
            
            sentimentAvgs.append(sentiment)

            do {
                try dataForDavid.addDataPoint(
                    input: dataSet.asArray,
                    output: dataSet.output,
                    label: security.date.asString)
                
                GraniteLogger.info(dataSet.description, .ml, symbol: "🛠")
            }
            catch {
                GraniteLogger.error("invalid dataSet", .ml)
            }

            let david = SVMModel(
                problemType: .ϵSVMRegression,
                kernelSettings:
                KernelParameters(type: .Polynomial,
                                 degree: 3,
                                 gamma: 0.3,
                                 coef0: 0.0))

            david.Cost = 1e3
            david.train(data: dataForDavid)

            switch type.model(for: david) {
            case .close(let model):
                self.close = model
            case .high(let model):
                self.high = model
            case .low(let model):
                self.low = model
            case .volume(let model):
                self.volume = model
            }
//            modelsToAppend.append(type.model(for: david))
        }
        
        self.created = quote.latestSecurity.date
        
//        return .init(models: modelsToAppend, sentiments: sentimentAvgs)
    }
}
