//
//  BrowserState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public enum BrowserCompiledModelCreationStatus: String {
    case step1 = "select a base model"
    case step2 = "select models to merge"
    case step3 = "finish"
    case none = ""
}

public class BrowserCompiledModelCreationData: NSObject {
    
    let baseModel: StockModel
    let baseModelIndexPath: IndexPath
    @objc dynamic var modelsToMerge: [String: CompiledMergeModelData] = [:]
    @objc dynamic var compatibleModels: [StockModel] = []
    
    public init(baseModel: StockModel, baseModelIndexPath: IndexPath) {
        self.baseModel = baseModel
        self.baseModelIndexPath = baseModelIndexPath
    }
    
    public class CompiledMergeModelData: NSObject {
        let model: StockModel
        let indexPath: IndexPath
        
        public init(_ model: StockModel, _ indexPath: IndexPath) {
            self.model = model
            self.indexPath = indexPath
        }
    }
}

public class BrowserState: State {
    @objc dynamic var nextValidTradingDay: String = "unknown"
    @objc dynamic var currentCompiledCreationStatus: String = BrowserCompiledModelCreationStatus.none.rawValue
    @objc dynamic var compiledModelCreationData: BrowserCompiledModelCreationData? = nil
    
    var currentCompiledStatus: BrowserCompiledModelCreationStatus {
        return BrowserCompiledModelCreationStatus.init(rawValue: currentCompiledCreationStatus) ?? .none
    }
    
    let mergedModels: [StockModelMerged]
    
    public init(_ mergedModels: [StockModelMerged]) {
        self.mergedModels = mergedModels
    }
}
