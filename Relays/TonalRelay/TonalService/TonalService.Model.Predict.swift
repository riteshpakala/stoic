//
//  TonalService.Model.Predict.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/20/21.
//

import Foundation
import GraniteUI
import CoreData

//MARK: -- Predict
extension TonalModels {
    public func scale(prediction: Double,
                      _ value: Double) -> Double {
        GraniteLogger.info("scaling: \(prediction) to: \(value)", .ml)
        return (value*prediction) + value
    }
    
    public func predict(_ quote: Quote,
                        _ modelType: ModelType = .close,
                        range: [Date],
                        sentiment: SentimentOutput) -> Double? {
        
        let sortedSecurities = quote.securities.sortDesc
        
        let sortedRange = range.sortDesc
        
        // We want to predict based off the "next day" in the sequence
        // of days used to train the model that would be based on days
        // of the past. Combines with today's sentiment, let's see
        // how the future can meet the past.
        //
        guard let firstRangeDate = sortedRange.first,
              let firstSecurity = sortedSecurities.first else { return nil }
        
        
        guard firstRangeDate.simple != firstSecurity.date.simple else {
            //Is the base range.
            return run(firstSecurity, sentiment, quote, modelType)
        }
        
        //Same get's the "next" stock ahead of the date range specified.
        guard let lastSecurity = sortedSecurities.filterAbove(firstRangeDate).last else {
            return nil
        }
        
        return run(lastSecurity, sentiment, quote, modelType)
    }
    
    public func predict(_ tone: Tone,
                        _ sentiment: SentimentOutput,
                        _ modelType: ModelType = .close,
                        moc: NSManagedObjectContext,
                        _ completion: @escaping ((Double) -> Void)) {
        
        guard let selectedRange = tone.selectedRange else {
            GraniteLogger.error("failed to retrieve selected tonal range - self: \(self)", .relay)
            completion(0.0)
            return
        }
        
        selectedRange.objects.first?.getQuote(moc: moc) { [weak self] quote in
            guard let quote = quote else {
                GraniteLogger.error("failed to retrieve quote - self: \(self)", .relay)
                completion(0.0)
                return
            }
            
            let sortedSecurities = quote.securities.sortDesc
            let security: Security
            
            if selectedRange.base {
                guard let baseSecurity = sortedSecurities.first else {
                    completion(0.0); return }
                security = baseSecurity
            } else {
                let sortedRange = selectedRange.objects.sortDesc
                
                // We want to predict based off the "next day" in the sequence
                // of days used to train the model that would be based on days
                // of the past. Combines with today's sentiment, let's see
                // how the future can meet the past.
                //
                guard let firstRangeSecurity = sortedRange.first else {
                    completion(0.0); return }
                
                guard let lastSecurity = sortedSecurities.filterAbove(firstRangeSecurity.date).last else {
                    completion(0.0); return
                }
                
                security = lastSecurity
            }
            
            completion(self?.run(security, sentiment, quote, modelType) ?? 0.0)
        }
    }
    
    public func run(_ security: Security,
                    _ sentiment: SentimentOutput,
                    _ quote: Quote,
                    _ modelType: ModelType) -> Double? {
        let testData = DataSet(
            dataType: .Regression,
            inputDimension: self.currentType.inDim,
            outputDimension: TonalService.AI.Models.Settings.outDim)
        
        do {
            let dataSet = TonalService.AI.Models.DataSet(
                    security,
                    sentiment,
                    quote: quote,
                    modelType: self.currentType,
                    predicting: true)
            
            GraniteLogger.info("predicting:\n\(dataSet.description)\nself: \(self)", .relay)
            
            try testData.addTestDataPoint(input: dataSet.asArray)
        }
        catch {
            GraniteLogger.error("invalid dataSet", .ml)
        }
        
        self.model(forType: modelType)?.predictValues(data: testData)
        guard let output = testData.singleOutput(index: 0) else {
            return nil
        }
        
        GraniteLogger.info("predicting for: \(modelType)\noutput: \(output)\nself: \(self)", .ml)
        
        switch modelType {
        case .close:
            return (output - security.lastValue) / security.lastValue
        case .high:
            return (output - security.highValue) / security.highValue
        case .low:
            return (output - security.lowValue) / security.lowValue
        case .volume:
            return (output - security.volumeValue) / security.volumeValue
        case .stochasticK:
            return output
        case .stochasticD:
            return output
        default:
            return nil
        }
    }
    
    public func testPredict(tone: Tone, moc: NSManagedObjectContext) {
        predict(tone, .neutral, moc: moc) { prediction in
            GraniteLogger.info("test prediction output: \(prediction)\nself: \(self)", .ml)
        }
    }
}
