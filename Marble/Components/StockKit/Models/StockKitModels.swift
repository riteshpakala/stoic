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

public class StockKitModels: NSObject, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public static let engine: String = "david.v0.00.00"

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
                return 7
            default:
                return 8
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
            
            print("[MODEL GENERATION] Creating model for \(type)")
            for (i, stock) in sortedStockData.enumerated() {
                do {
                    guard sortedSentimentStockData.count > i else { continue }
                    let sentiment = sortedSentimentStockData[i]
                    let dataSet = StockKitUtils.Models.DataSet(
                        stock,
                        sentiment,
                        modelType: type)
                    
                    
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
    
    public var open: SVMModel?
    public var close: SVMModel?
    public var high: SVMModel?
    public var low: SVMModel?
    public var volume: SVMModel?
    
    public var currentType: ModelType = .none
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
    }
    
    public required convenience init?(coder: NSCoder) {
        let openModel: SVMModel? = try? coder.decodeTopLevelObject(forKey: "open") as? SVMModel
        let closeModel: SVMModel? = try? coder.decodeTopLevelObject(forKey: "close") as? SVMModel
        let highModel: SVMModel? = try? coder.decodeTopLevelObject(forKey: "high") as? SVMModel
        let lowModel: SVMModel? = try? coder.decodeTopLevelObject(forKey: "low") as? SVMModel
        let volumeModel: SVMModel? = try? coder.decodeTopLevelObject(forKey: "volume") as? SVMModel
        let currentType: Int = coder.decodeInteger(forKey: "currentType")
        
        self.init(
            models: [])
        
        self.open = openModel
        self.close = closeModel
        self.high = highModel
        self.low = lowModel
        self.volume = volumeModel
        self.currentType = ModelType.init(rawValue: currentType) ?? .none
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(open, forKey: "open")
        coder.encode(close, forKey: "close")
        coder.encode(high, forKey: "high")
        coder.encode(low, forKey: "low")
        coder.encode(volume, forKey: "volume")
        coder.encode(currentType.rawValue, forKey: "currentType")
    }
}
