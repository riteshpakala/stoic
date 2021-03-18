//
//  StrategyEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct StrategyEvents {
    public struct Get: GraniteEvent {
        public var async: DispatchQueue? {
            GraniteThread.event
        }
        
        public struct Meta: GraniteEvent {
            public var async: DispatchQueue? {
                GraniteThread.event
            }
        }
    }
    public struct Train: GraniteEvent {
        
    }
    public struct Reset: GraniteEvent {}
    public struct Remove: GraniteEvent {
        let assetID: String
    }
    public struct Close: GraniteEvent {
        let assetID: String
    }
    public struct Sync: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
        
        public var async: DispatchQueue? {
            GraniteThread.event
        }
    }
    public struct Predict: GraniteEvent {
        public var async: DispatchQueue? {
            GraniteThread.event
        }
    }
    public struct Push: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct SyncComplete: GraniteEvent {}
    public struct PickModel: GraniteEvent {
        let assetID: String
    }
    
    public struct Tone {
        public struct Request: GraniteEvent {
            let change: Strategy.Investments.Item.Change
            let item: Strategy.Investments.Item
            public var async: DispatchQueue? {
                GraniteThread.event
            }
        }
    }
}
