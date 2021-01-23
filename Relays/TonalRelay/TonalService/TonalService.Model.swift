//
//  TonalService.Model.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation
import GraniteUI
import CoreData

public class TonalModels: Archiveable {
    
    public static let engine: String = "david.v00.02.00"
    
    public var close: SVMModel?
    public var high: SVMModel?
    public var low: SVMModel?
    public var volume: SVMModel?
    
    public var recentSecurity: Security?
    
    public var currentType: ModelType = .close
    
    public init(models: [Model]) {
        for model in models {
            switch model {
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
        case high
        case close
        case low
        case volume
        case stochasticK
        case stochasticD
        case currentType
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let closeModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .close)
        
        let highModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .high)
        
        let lowModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .low)
        
        let volumeModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .volume)
        
        let typeValue: Int = try container.decode(Int.self, forKey: .currentType)
        
        self.init(
            models: [])
        
        self.close = closeModel
        self.high = highModel
        self.low = lowModel
        self.volume = volumeModel
        self.currentType = ModelType.init(rawValue: typeValue) ?? .none
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(close, forKey: .close)
        
        try container.encode(high, forKey: .high)
        
        try container.encode(low, forKey: .low)
        
        try container.encode(volume, forKey: .volume)
        
        try container.encode(currentType.rawValue, forKey: .currentType)
    }
}

//MARK: -- Helpers
extension TonalModels {
    public var current: SVMModel? {
        switch currentType {
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
    public func modelType(forModel model: SVMModel) -> ModelType {
        switch model {
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
        case close(SVMModel)
        case high(SVMModel)
        case low(SVMModel)
        case volume(SVMModel)
        
        var type: ModelType {
            switch self {
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
            case .close:
                return .close(model)
            case .high:
                return .high(model)
            case .low:
                return .low(model)
            case .volume:
                return .volume(model)
            default:
                return .close(model)
            }
        }
        
        var symbol: String {
            switch self {
            case .none:
                return ""
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
