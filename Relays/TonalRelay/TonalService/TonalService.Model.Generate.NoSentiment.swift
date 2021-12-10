//
//  TonalService.Model.Generate.NoSentiment.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/11/21.
//

import Foundation
import GraniteUI
import CoreData

extension TonalModels {
    public static func generate(fromQuote quoteToUse: Quote,
                                fromDate date: Date,
                                days: Int = 12,
                                moc: NSManagedObjectContext? = nil) -> TonalModel? {
        var quote = quoteToUse
        
        quote.precompute()
        
        let securities = quote.securities.sortAsc
        
        guard let index = securities.firstIndex(where: { $0.date == date }),
              index-days >= 0 else { return nil }
        
        //Securities part of window of days
        let trainables = securities[index-days...index]
        
        GraniteLogger.info("generating tonal model w/o sentiment", .ml, focus: true, symbol: "🛠")
        
        var models: [TonalModels.Model] = []
        for modelType in ModelType.allCases {
            guard modelType != .none else { continue }
            
            GraniteLogger.info("-- working on: \(modelType) --", .ml, focus: true, symbol: "🚧")
            let type: ModelType = modelType
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: type.inDimNoSentiment,
                outputDimension: TonalService.AI.Models.Settings.outDim)
            
            for security in trainables {
                do {
                    let dataSet = TonalService.AI.Models.DataSetNoSentiment(
                        security,
                        quote: quote,
                        modelType: type)
                    
                    if modelType == .close {
                        GraniteLogger.info("inserting dataSet:\n\(dataSet.description)", .ml, focus: true)
                    }
                    
                    try dataForDavid.addDataPoint(
                        input: dataSet.asArray,
                        output: dataSet.output,
                        label: security.date.asString)
                }
                catch {
                    GraniteLogger.info("invalid dataSet", .ml, focus: true)
                }
            }
            GraniteLogger.info("training", .ml, focus: true)
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
        
        let tonalModel: TonalModels = .init(models: models, created: date)
        
        //Save if moc provided
        if let coreDataInstance = moc {
            if tonalModel.save(forQuote: quote, range: trainables.map { $0.date }, moc: coreDataInstance) != nil {
                
                GraniteLogger.info("tonal model saved without sentiment", .ml, focus: true)
            } else {
                GraniteLogger.info("tonal model failed to save", .ml, focus: true)
            }
        }
        
        return .init(tonalModel,
                     daysTrained: days,
                     tuners: tonalModel.sentiments,
                     quote: quote,
                     range: securities.map { $0.date },
                     isStrategy: false)
    }
}
