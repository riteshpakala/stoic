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
    
    public struct MergeModel: Event {
        
    }
}
