//
//  TonalService.Model.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation
import GraniteUI

public class TonalModels: Archiveable {
    
    public static let engine: String = "david.v00.02.00"
    
    public struct Settings {
        static let inDim: Int = 8
        static let outDim: Int = 1
    }
    
    public var open: SVMModel?
    public var close: SVMModel?
    public var high: SVMModel?
    public var low: SVMModel?
    public var volume: SVMModel?
    
    public var recentSecurity: Security?
    
    public var currentType: ModelType = .close
    
    public init(models: [Model]) {
        for model in models {
            switch model {
            case .open(let svmModel):
                open = svmModel
            case .close(let svmModel):
                close = svmModel
            case .high(let svmModel):
                high = svmModel
            case .low(let svmModel):
                low = svmModel
            case .volume(let svmModel):
                volume = svmModel
            }
        }
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case open
        case close
        case high
        case low
        case volume
        case currentType
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let openModel: SVMModel = try container.decode(SVMModel.self, forKey: .open)
        
        let closeModel: SVMModel = try container.decode(SVMModel.self, forKey: .close)
        
        let highModel: SVMModel = try container.decode(SVMModel.self, forKey: .high)
        
        let lowModel: SVMModel = try container.decode(SVMModel.self, forKey: .low)
        
        let volumeModel: SVMModel = try container.decode(SVMModel.self, forKey: .volume)
        
        let typeValue: Int = try container.decode(Int.self, forKey: .currentType)
        
        self.init(
            models: [])
        
        self.open = openModel
        self.close = closeModel
        self.high = highModel
        self.low = lowModel
        self.volume = volumeModel
        self.currentType = ModelType.init(rawValue: typeValue) ?? .none
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let open = self.open, let close = self.close, let high = self.high, let low = self.low, let volume = self.volume {
            try container.encode(open, forKey: .open)
            
            try container.encode(close, forKey: .close)
            
            try container.encode(high, forKey: .high)
            
            try container.encode(low, forKey: .low)
            
            try container.encode(volume, forKey: .volume)
            
            try container.encode(currentType.rawValue, forKey: .currentType)
        }
    }
}

//MARK: -- Predict
extension TonalModels {
    public func predict(_ security: Security,
                        _ sentiment: SentimentOutput) -> Double? {
        
        return nil
    }
    
    public func testPredict(tone: Tone) {
        guard let security = self.recentSecurity else { return }
        
        guard let quote = tone.selectedRange?.objects.first?.quote?.asQuote else {
            print("⚠️ Test prediction failed.")
            return
        }
        
        let testData = DataSet(
            dataType: .Regression,
            inputDimension: self.currentType.inDim,
            outputDimension: StockKitUtils.outDim)
        
        do {
            let dataSet = TonalUtilities.Models.DataSet(
                    security,
                    .neutral,
                    quote: quote,
                    modelType: self.currentType)
            
            print("💡💡💡💡💡💡\n[PREDICTING]\n\(dataSet.description)\n💡")
            
            try testData.addTestDataPoint(
               input: dataSet.asArray)
        }
        catch {
           print("Invalid data set created")
        }
        
        self.current?.predictValues(data: testData)
   
        guard let output = testData.singleOutput(index: 0) else {
            return
        }

        print("🧬🧬🧬🧬🧬🧬\n[Prediction Output] :: \(output)\n🧬")
    }
}

//MARK: -- Generate
extension TonalModels {
    public static func generate(tone: Tone, testable: Bool = false) -> TonalModels? {
        guard let securityObjects = tone.selectedRange?.objects else {
            print("⚠️ Generation failed. - securityObjects")
            return nil
        }
        
        guard let quote = securityObjects.first?.quote?.asQuote else {
            print("⚠️ Generation failed. - quote")
            return nil
        }
        
        var securities = securityObjects.compactMap { $0.asSecurity }
        var sentiments = tone.tune.sentiments
        
        if testable {
            if let security = securities.sortDesc.first {
                securities = securities.suffix(securities.count - 1)
                if let key = sentiments.keys.first(where: { $0.simple == security.date.simple }) {
                    sentiments.removeValue(forKey: key)
                }
            }
        }
        
        let dates = Array(sentiments.keys).sorted(by: { $0.compare($1) == .orderedAscending } )
        
        // Time-series execution's foundation is that
        // the time comparable is equivalent to the data
        // size
        guard dates.count == securities.count else {
            print("⚠️ Generation failed. - dates: \(dates.count), securities: \(securities.count)")
            return nil
        }
        
        // DEV: by day enforced for now
        // and `close` prediction
        //
        let type: ModelType = .close
        let dataForDavid: DataSet = DataSet(
                                    dataType: .Regression,
                                    inputDimension: type.inDim,
                                    outputDimension: TonalModels.Settings.outDim)

        print("🛠 [MODEL GENERATION] Creating model for \(type)")
        for date in dates {
            guard let sentiment = sentiments[date.simple],
                  let security = securities.first(where: { $0.date.simple == date.simple }) else {
                continue
            }

            do {
                let dataSet = TonalUtilities.Models.DataSet(
                    security,
                    sentiment,
                    quote: quote,
                    modelType: type)

                print(dataSet.description)
                
                try dataForDavid.addDataPoint(
                    input: dataSet.asArray,
                    output: dataSet.output,
                    label: security.date.asString)
            }
            catch {
                print("Invalid data set created")
            }
        }
        
        print("🛠 ✅ [MODEL GENERATION] Creating model complete")
        print("data points added: \(dataForDavid.labels.count)")
        print("data points expected: \(securities.count)")
        print("data points asserted: \(securities.count == dataForDavid.labels.count)")

        let david = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 3,
                             gamma: 0.3,
                             coef0: 0.0))

        david.Cost = 1e3
        david.train(data: dataForDavid)
        
        //DEV:
        let models: TonalModels = .init(models: [.close(david)])
        // Store the head for a most recent
        // prediction in testing, etc.
        //
        if testable {
            models.recentSecurity = securityObjects.compactMap { $0.asSecurity }.sorted(by: { $0.date.compare($1.date) == .orderedDescending }).first
        }
        return models
    }
}

//MARK: -- Helpers
extension TonalModels {
    public var current: SVMModel? {
        switch currentType {
        case .open:
            return open
        case .close, .none:
            return close
        case .high:
            return high
        case .low:
            return low
        case .volume:
            return volume
        }
    }
    public func modelType(forModel model: SVMModel) -> ModelType {
        switch model {
        case open:
            return .open
        case close:
            return .close
        case high:
            return .high
        case low:
            return .low
        case volume:
            return .volume
        default:
            return .none
        }
    }
    public func model(forType type: ModelType) -> SVMModel? {
        switch type {
        case .open:
            return open
        case .close:
            return close
        case .high:
            return high
        case .low:
            return low
        case .volume:
            return volume
        default:
            return close
        }
    }
}

//MARK: -- Storage Models
extension TonalModels {
    public enum Model {
        case open(SVMModel)
        case close(SVMModel)
        case high(SVMModel)
        case low(SVMModel)
        case volume(SVMModel)
        
        var type: ModelType {
            switch self {
            case .open(_):
                return .open
            case .close(_):
                return .close
            case .high(_):
                return .high
            case .low(_):
                return .low
            case .volume(_):
                return .volume
            }
        }
        
        var model: SVMModel {
            switch self {
            case .open(let model):
                return model
            case .close(let model):
                return model
            case .high(let model):
                return model
            case .low(let model):
                return model
            case .volume(let model):
                return model
            }
        }
    }
    
    public enum ModelType: Int, CaseIterable {
        case open
        case close
        case high
        case low
        case volume
        case none
        
        var inDim: Int {
            switch self {
            case .volume:
                return 5
            default:
                return 7
            }
        }
        
        func model(for model: SVMModel) -> Model {
            switch self {
            case .open:
                return .open(model)
            case .close, .none:
                return .close(model)
            case .high:
                return .high(model)
            case .low:
                return .low(model)
            case .volume:
                return .volume(model)
            }
        }
        
        var symbol: String {
            switch self {
            case .volume:
                return ""
            default:
                return "$"
            }
        }
        
        public static func forValue(_ string: String) -> ModelType {
            for type in ModelType.allCases {
                if "\(type)" == string {
                    return type
                }
            }
            
            return .none
        }
    }
}

//BACKUP

//        let sortedStockData = stockData.sorted(
//            by: {
//                ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedAscending })
//
//
//        let sortedSentimentStockData = sentimentData.sorted(
//            by: {
//                ($0.date).compare($1.date) == .orderedAscending })
//
//
//        var models: [Model] = []
//        var type: ModelType = .close
//        //Only the close for now
////        for type in ModelType.allCases {
//            let dataForDavid: DataSet = DataSet(
//                dataType: .Regression,
//                inputDimension: type.inDim,
//                outputDimension: TonalModels.Settings.outDim)
//
//            print("[MODEL GENERATION] Creating model for \(type) \(sortedStockData.isEmpty)")
//            for (i, stock) in sortedStockData.enumerated() {
//                do {
//                    guard sortedSentimentStockData.count > i else { continue }
//                    let sentiment = sortedSentimentStockData[i]
//                    let dataSet = StockKitUtils.Models.DataSet(
//                        stock,
//                        sentiment,
//                        modelType: type)
//
//                    print(stock.toString)
//                    try dataForDavid.addDataPoint(
//                        input: dataSet.asArray,
//                        output: dataSet.output,
//                        label: stock.dateData.asString)
//                }
//                catch {
//                    print("Invalid data set created")
//                }
//            }
//
//            let david = SVMModel(
//                problemType: .ϵSVMRegression,
//                kernelSettings:
//                KernelParameters(type: .Polynomial,
//                                 degree: 3,
//                                 gamma: 0.3,
//                                 coef0: 0.0))
//
//            david.Cost = 1e3
//            david.train(data: dataForDavid)
//
//            print("[MODEL GENERATION] Completed training model for \(type)")
//
//            models.append(type.model(for: david))
////        }
//
//        return TonalModels.init(models: models)
