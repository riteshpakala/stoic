//
//  StockIndicators.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/19/20.
//

import Foundation

public class RSI: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    let open: Double
    let close: Double
    let maxRSI: Int
    
    
    public init(open: Double, close: Double, maxRSI: Int) {
        self.open = open
        self.close = close
        self.maxRSI = maxRSI
    }
    
    public required convenience init?(coder: NSCoder) {
        let open: Double = coder.decodeDouble(forKey: "open")
        let close: Double = coder.decodeDouble(forKey: "close")
        let maxRSI: Int = coder.decodeInteger(forKey: "maxRSI")

        self.init(
            open: open,
            close: close,
            maxRSI: maxRSI)
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(open, forKey: "open")
        coder.encode(close, forKey: "close")
        coder.encode(maxRSI, forKey: "maxRSI")
    }
    
    static var zero: RSI {
        return .init(open: 0, close: 0.0, maxRSI: 20)
    }
}

public class Momentum: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    private var momentums: [String: Int]
    
    private var volatilities: [String: Double]
    
    private(set) var dayAverage: Double
    
    public override init() {
        momentums = [:]
        volatilities = [:]
        dayAverage = 0.0
        super.init()
    }
    public init(
        prevStock: StockData, nextStock: StockData) {
        
        momentums = [:]
        volatilities = [:]
        for item in StockKitModels.ModelType.allCases {
            momentums["\(item)"] = prevStock.charateristic(forModelType: item) > nextStock.charateristic(forModelType: item) ? 1 : -1
            volatilities["\(item)"] = (prevStock.charateristic(forModelType: item) - nextStock.charateristic(forModelType: item))/2
        }
        self.dayAverage = (prevStock.close + prevStock.open)/2
    }
    
    public required convenience init?(coder: NSCoder) {
        let momentums: [String: Int] = (coder.decodeObject(forKey: "momentums") as? [String: Int]) ?? [:]
        let volatilities: [String: Double] = (coder.decodeObject(forKey: "volatilities") as? [String: Double]) ?? [:]
        let dayAverage: Double = coder.decodeDouble(forKey: "dayAverage")

        self.init()
        
        self.momentums = momentums
        self.volatilities = volatilities
        self.dayAverage = dayAverage
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(momentums, forKey: "momentums")
        coder.encode(volatilities, forKey: "volatilities")
        coder.encode(dayAverage, forKey: "dayAverage")
    }
    
    func momentum(forModelType type: StockKitModels.ModelType) -> Int {
        return momentums["\(type)"] ?? 0
    }
    
    func volatility(forModelType type: StockKitModels.ModelType) -> Double {
        return volatilities["\(type)"] ?? 0.0
    }
    
    static var zero: Momentum {
        return .init(prevStock: .empty, nextStock: .empty)
    }
}

public class Averages: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    private var momentums: [String: Double]
    
    private var volatilities: [String: Double]
    
    let volume: Double
    let sma20: Double
    
    public init(momentums: [String: Double], volatilities: [String: Double], volume: Double, sma20: Double) {
        self.momentums = momentums
        self.volatilities = volatilities
        self.volume = volume
        self.sma20 = sma20
    }
    public init(
        history: [StockData]) {
        
        let historicalFeatures = history.map { $0.features }
        
        momentums = [:]
        volatilities = [:]
        for item in StockKitModels.ModelType.allCases {
            let sumOfMomentums: Double = Double(historicalFeatures.map { $0?.momentum(forModelType: item) ?? 0 }.reduce(0, +))
            let sumOfVolatilities: Double = (historicalFeatures.map { $0?.volatility(forModelType: item) ?? 0.0 }.reduce(0, +))
            
            momentums["\(item)"] = sumOfMomentums/Double(historicalFeatures.count)
            volatilities["\(item)"] = sumOfVolatilities/Double(historicalFeatures.count)
        }
        
        let volumeAVG = Double(history.map { $0.volume }.reduce(0, +)) / Double(history.count)
        let sma20 = Double(historicalFeatures.suffix(20).map { $0?.dayAverage ?? 0 }.reduce(0, +)) / (20.0)
        
        self.volume = volumeAVG
        self.sma20 = sma20
    }
    
    public required convenience init?(coder: NSCoder) {
        let momentums: [String: Double] = (coder.decodeObject(forKey: "momentums") as? [String: Double]) ?? [:]
        let volatilities: [String: Double] = (coder.decodeObject(forKey: "volatilities") as? [String: Double]) ?? [:]
        let volume: Double = coder.decodeDouble(forKey: "volume")
        let sma20: Double = coder.decodeDouble(forKey: "sma20")

        self.init(
            momentums: momentums,
            volatilities: volatilities,
            volume: volume,
            sma20: sma20)
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(momentums, forKey: "momentums")
        coder.encode(volatilities, forKey: "volatilities")
        coder.encode(volume, forKey: "volume")
        coder.encode(sma20, forKey: "sma20")
    }
    
    static var zero: Averages {
        return .init(momentums: [:], volatilities: [:], volume: 0.0, sma20: 0.0)
    }
    
    func momentum(forModelType type: StockKitModels.ModelType) -> Double {
        return momentums["\(type)"] ?? 0.0
    }
    
    func volatility(forModelType type: StockKitModels.ModelType) -> Double {
        return volatilities["\(type)"] ?? 0.0
    }
}
