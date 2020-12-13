//
//  StockKitModels.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/28/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public enum StockPrediction {
    case high
    case low
    case open
    case close
}

public class StockKitModels: Archiveable {
//    public static var supportsSecureCoding: Bool = true
    
    public static let engine: String = "david.v00.01.10"

//    var open: Double
//    var high: Double
//    var low: Double
//    var close: Double
//    var adjClose: Double //X-Dividend
//    var volume: Double
    
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
    
    public static func generate(stockData: [StockData], sentimentData: [StockSentimentData]) -> StockKitModels {
        
        let sortedStockData = stockData.sorted(
            by: {
                ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedAscending })
        
        
        let sortedSentimentStockData = sentimentData.sorted(
            by: {
                ($0.date).compare($1.date) == .orderedAscending })
        
        
        var models: [Model] = []
        for type in ModelType.allCases {
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: type.inDim,
                outputDimension: StockKitUtils.outDim)
            
            print("[MODEL GENERATION] Creating model for \(type) \(sortedStockData.isEmpty)")
            for (i, stock) in sortedStockData.enumerated() {
                do {
                    guard sortedSentimentStockData.count > i else { continue }
                    let sentiment = sortedSentimentStockData[i]
                    let dataSet = StockKitUtils.Models.DataSet(
                        stock,
                        sentiment,
                        modelType: type)
                    
                    print(stock.toString)
                    try dataForDavid.addDataPoint(
                        input: dataSet.asArray,
                        output: dataSet.output,
                        label: stock.dateData.asString)
                }
                catch {
                    print("Invalid data set created")
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
            
            print("[MODEL GENERATION] Completed training model for \(type)")
            
            models.append(type.model(for: david))
        }
        
        return StockKitModels.init(models: models)
    }
    
    public static func merge(modelObjects: [StockModel]) -> StockKitModels {
        
        var models: [Model] = []
        for type in ModelType.allCases {
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: type.inDim,
                outputDimension: StockKitUtils.outDim)
            
            let modelObjectsForType = modelObjects.compactMap { $0.model?.model(forType: type) }
            
            print("[MODEL GENERATION] MERGING model for \(type)")
            let dataSets = modelObjectsForType.compactMap { $0.dataSet }
            do {
                for set in dataSets {
                    for i in 0..<set.labels.count {
                        try dataForDavid.addDataPoint(
                            input: set.inputs[i],
                            output: set.outputs?[i] ?? [],
                            label: set.labels[i])
                        print("[MODEL GENERATION] \(set.labels[i])")
                    }
                }
            } catch {
                print("{SVM} Invalid data set created")
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

            print("[MODEL GENERATION] Completed merging model for \(type)")

            models.append(type.model(for: david))
        }
        
        return StockKitModels.init(models: models)
        
    }
    
    public static func appendADay(models: StockKitModels, stockData: [StockData], sentimentData: StockSentimentData, tradingDay: String) -> (StockData, StockKitModels)? {
        
        guard let recentStock = stockData.sorted(
            by: {
                ($0.dateData.asDate ?? Date())
                    .compare(($1.dateData.asDate ?? Date())) == .orderedDescending
            }).first else {
            return nil
        }
        
        let newStock: StockData = StockData.empty
        for type in ModelType.allCases {
            guard let model = models.model(forType: type) else {
                continue
            }
            
            let testData = DataSet(
               dataType: .Regression,
               inputDimension: type.inDim,
               outputDimension: StockKitUtils.outDim)
            
            do {
                let dataSet = StockKitUtils.Models.DataSet(
                    recentStock,
                    sentimentData,
                    modelType: type,
                    updated: true)
                
                print("********************\nPREDICTING\n\(dataSet.description)")
                
                try testData.addTestDataPoint(
                   input: dataSet.asArray)
            }
            catch {
               print("Invalid data set created")
            }
            
            model.predictValues(data: testData)
            
            if let output = testData.singleOutput(index: 0) {
                switch type {
                case .open:
                    newStock.open = output
                case .close:
                    newStock.close = output
                    newStock.adjClose = output
                case .high:
                    newStock.high = output
                case .low:
                    newStock.low = output
                case .volume:
                    newStock.volume = output
                default:
                    continue
                }
            }
        }
        
        newStock.dateData = .init(tradingDay)
        var historicalData = recentStock.historicalData
        historicalData?.append(recentStock)
        
        if let historical = historicalData, let maxRSI = recentStock.rsi?.maxRSI {
            _ = newStock.update(historicalTradingData: historical, rsiMax: maxRSI)
        }
        
        var modelsToAppend: [Model] = []
        for type in ModelType.allCases {
            guard let model = models.model(forType: type), let dataForDavid = model.dataSet else {
                continue
            }

            print("[MODEL GENERATION] Adding a day to a model for \(type) \(tradingDay)")
            let dataSet = StockKitUtils.Models.DataSet(
                newStock,
                sentimentData,
                modelType: type)

            do {
                try dataForDavid.addDataPoint(
                    input: dataSet.asArray,
                    output: dataSet.output,
                    label: newStock.dateData.asString)
            }
            catch {
               print("Invalid data set created")
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

            print("[MODEL GENERATION] Completed adding a day to model for \(type)")

            modelsToAppend.append(type.model(for: david))
            
        }
        
        return (newStock, StockKitModels.init(models: modelsToAppend))
        
    }
    
    struct LastPrediction {
        let positive: Double = 0.5
        let negative: Double = 0.5
        let neutral: Double = 0.0
        let compound: Double = 0.0
    }
    
    public var open: SVMModel?
    public var close: SVMModel?
    public var high: SVMModel?
    public var low: SVMModel?
    public var volume: SVMModel?
    
    public var currentType: ModelType = .open
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
