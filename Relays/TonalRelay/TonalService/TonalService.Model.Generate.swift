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
            GraniteLogger.error("failed to retrieve range\nself: \(self)", .relay)
            completion(nil)
            return
        }
        
        let securityObjects = range.objects
        
        securityObjects.first?.getQuote(moc: moc) { quote in
            guard let quote = quote else {
                GraniteLogger.error("failed to retrieve quote\nself: \(self)", .relay)
                completion(nil)
                return
            }
            
            let securities = securityObjects
            let sentiments = tone.tune.sentiments
            
            let bucket: TonalService.AI.Models.Bucket = .init(sentiments: sentiments, range: range)
            
            
            // Time-series execution's foundation is that
            // the time comparable is equivalent to the data
            // size
            guard bucket.isValid else {
                GraniteLogger.error("failed to bucket\n\(bucket.pockets.count)\n\(bucket.rangeDates)\nself: \(self)", .relay)
                return
            }
            
            GraniteLogger.info("generating tonal model", .ml, focus: true, symbol: "🛠")
            
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
                        continue
                    }

                    do {
                        let dataSet = TonalService.AI.Models.DataSet(
                            security,
                            pocket.avg,
                            quote: quote,
                            modelType: type)
                        
                        GraniteLogger.info("inserting dataSet:\n\(dataSet.inputDescription)", .ml)
                        
                        try dataForDavid.addDataPoint(
                            input: dataSet.asArray,
                            output: dataSet.output,
                            label: security.date.asString)
                    }
                    catch {
                        GraniteLogger.error("invalid dataSet", .ml)
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
            
            completion(.init(models: models))
        }
    }
}
