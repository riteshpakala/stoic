//
//  BrowserEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct BrowserEvents {
    public struct BaseModelSelected: Event {
        let model: StockModel?
        let indexPath: IndexPath
        public init(_ model: StockModel?, indexPath: IndexPath) {
            self.model = model
            self.indexPath = indexPath
        }
    }
    
    public struct ModelToMerge: Event {
        let model: StockModel
        let indexPath: IndexPath
        public init(_ model: StockModel, indexPath: IndexPath) {
            self.model = model
            self.indexPath = indexPath
        }
    }
    
    public struct CompiledModelCreationStatusUpdated: Event {
        let status: BrowserCompiledModelCreationStatus
        public init(_ status: BrowserCompiledModelCreationStatus) {
            self.status = status
        }
    }
    
    public struct MergeModel: Event {}
    
    public struct StandaloneModelSelected: Event {
        let model: StockModel
        let indexPath: IndexPath
        public init(_ model: StockModel, indexPath: IndexPath) {
            self.model = model
            self.indexPath = indexPath
        }
    }
    
    public struct MergeModelSelected: Event {
        let model: StockModelMergedObject
        public init(_ model: StockModelMergedObject) {
            self.model = model
        }
    }
    
    public struct RemoveModel: Event {
        let id: String
        public init(_ id: String) {
            self.id = id
        }
    }
}
