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
        
        let openModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .open)
        
        let closeModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .close)
        
        let highModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .high)
        
        let lowModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .low)
        
        let volumeModel: SVMModel? = try? container.decode(SVMModel.self, forKey: .volume)
        
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
        
        try container.encode(open, forKey: .open)
        
        try container.encode(close, forKey: .close)
        
        try container.encode(high, forKey: .high)
        
        try container.encode(low, forKey: .low)
        
        try container.encode(volume, forKey: .volume)
        
        try container.encode(currentType.rawValue, forKey: .currentType)
    }
}

//MARK: -- Predict
extension TonalModels {
    public func scale(prediction: Double,
                      _ value: Double) -> Double {
        
        return (value*prediction) + value
    }
    public func predict(_ quote: Quote,
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
            return run(firstSecurity, sentiment, quote)
        }
        
        //Same get's the "next" stock ahead of the date range specified.
        guard let lastSecurity = sortedSecurities.filterAbove(firstRangeDate).last else {
            return nil
        }
        
        return run(lastSecurity, sentiment, quote)
    }
    
    public func predict(_ tone: Tone,
                        _ sentiment: SentimentOutput,
                        moc: NSManagedObjectContext,
                        _ completion: @escaping ((Double) -> Void)) {
        
        guard let selectedRange = tone.selectedRange else {
            print("⚠️ Test prediction failed - selected range")
            completion(0.0)
            return
        }
        
        selectedRange.objects.first?.getQuote(moc: moc) { [weak self] quote in
            guard let quote = quote else {
                print("⚠️ Test prediction failed - quote")
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
            
            completion(self?.run(security, sentiment, quote) ?? 0.0)
        }
    }
    
    public func run(_ security: Security,
                    _ sentiment: SentimentOutput,
                    _ quote: Quote) -> Double? {
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
            
            print("💡💡💡💡💡💡\n[PREDICTING]\n\(dataSet.description)\n💡")
            
            try testData.addTestDataPoint(
               input: dataSet.asArray)
        }
        catch {
           print("Invalid data set created")
        }
        
        self.current?.predictValues(data: testData)
   
        guard let output = testData.singleOutput(index: 0) else {
            return nil
        }
        
        let change = (output - security.lastValue) / security.lastValue
        
        print("🧬🧬🧬🧬🧬🧬\n[Prediction Output] :: \(change)\n\(output) - \(security.lastValue)\n🧬")
        return change
    }
    
    public func testPredict(tone: Tone, moc: NSManagedObjectContext) {
        predict(tone, .neutral, moc: moc) { prediction in
            print("[TEST-PREDICTION] \(prediction)")
        }
    }
}

//MARK: -- Generate
extension TonalModels {
    public static func generate(tone: Tone,
                                moc: NSManagedObjectContext,
                                _ completion: @escaping ((TonalModels?) -> Void)) {
        guard let securityObjects = tone.selectedRange?.objects else {
            print("⚠️ Generation failed. - securityObjects")
            completion(nil)
            return
        }
        
        securityObjects.first?.getQuote(moc: moc) { quote in
            guard let quote = quote else {
                print("⚠️ Generation failed. - quote")
                completion(nil)
                return
            }
            guard let range = tone.selectedRange else {
                print("⚠️ Generation failed. - range")
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
                print("⚠️ Generation failed. \(bucket.pockets.count) \(bucket.rangeDates)")
                return
            }
            
            print(bucket.asString)
            
            // DEV: by day enforced for now
            // and `close` prediction
            //
            let type: ModelType = .close
            let dataForDavid: DataSet = DataSet(
                dataType: .Regression,
                inputDimension: type.inDim,
                outputDimension: TonalService.AI.Models.Settings.outDim)

            print("🛠 [MODEL GENERATION] Creating model for \(type)")
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

                    print(dataSet.inputDescription)
                    
                    try dataForDavid.addDataPoint(
                        input: dataSet.asArray,
                        output: dataSet.output,
                        label: security.date.asString)
                }
                catch {
                    print("Invalid data set created")
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
                
                completion(.init(models: [.close(david)]))
            }
        }
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
