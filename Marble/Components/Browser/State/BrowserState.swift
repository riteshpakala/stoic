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
    case step3 = "/**** compiling... */"
    case update = "select models to update"
    case none = ""
}

public class BrowserCompiledModelCreationData: NSObject {
    
    let baseModel: StockModel
    let baseModelIndexPath: IndexPath
    let isUpdating: Bool
    @objc dynamic var modelsToMerge: [String: CompiledMergeModelData] = [:]
    @objc dynamic var compatibleModels: [StockModel] = []
    
    public init(baseModel: StockModel, baseModelIndexPath: IndexPath = .init(item: 0, section: 0), isUpdating: Bool = false) {
        self.baseModel = baseModel
        self.baseModelIndexPath = baseModelIndexPath
        self.isUpdating = isUpdating
    }
    
    public class CompiledMergeModelData: NSObject {
        let model: StockModel
        let indexPath: IndexPath
        let isUpdating: Bool
        
        public init(_ model: StockModel, _ indexPath: IndexPath = .init(item: 0, section: 0), isUpdating: Bool = false) {
            self.model = model
            self.indexPath = indexPath
            self.isUpdating = isUpdating
        }
    }
}

public class BrowserState: State {
    @objc dynamic var subscription: Int = GlobalDefaults.Subscription.none.rawValue
    @objc dynamic var nextValidTradingDay: String = "unknown"
    @objc dynamic var currentCompiledCreationStatus: String = BrowserCompiledModelCreationStatus.none.rawValue
    @objc dynamic var compiledModelCreationData: BrowserCompiledModelCreationData? = nil
    @objc dynamic var isCompiling: Bool = false
    var daysFromTrading: Int = 1
    
    var currentCompiledStatus: BrowserCompiledModelCreationStatus {
        return BrowserCompiledModelCreationStatus.init(rawValue: currentCompiledCreationStatus) ?? .none
    }
    
    var mergedModels: [StockModelMerged]
    
    public init(_ mergedModels: [StockModelMerged]) {
        self.mergedModels = mergedModels
    }
}
