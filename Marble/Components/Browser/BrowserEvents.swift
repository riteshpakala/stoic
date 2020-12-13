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
        let stock: SearchStock?
        public init(_ status: BrowserCompiledModelCreationStatus, stock: SearchStock? = nil) {
            self.status = status
            self.stock = stock
        }
    }
    
    public struct MergeModel: Event {
        public enum MergeIntent {
            case deletion(StockModel?)
            case creation
        }
        let intent: MergeIntent
        public init(intent: MergeIntent = .creation){
            self.intent = intent
        }
    }
    
    public struct UpdateMergedModel: Event {
        let model: StockModelMergedObject
    }
    
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
        let lifecycle: StockModelMerged.Lifecycle
        public init(
            _ model: StockModelMergedObject,
            _ lifecycle: StockModelMerged.Lifecycle) {
            self.model = model
            self.lifecycle = lifecycle
        }
    }
    
    public struct RemoveModel: Event {
        let id: String
        public init(_ id: String) {
            self.id = id
        }
    }
    
    public struct UploadModel: Event {
        let model: StockModel?
        public init(_ model: StockModel?) {
            self.model = model
        }
    }
}
