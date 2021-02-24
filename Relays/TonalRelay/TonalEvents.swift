//
//  TonalEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalEvents {
    public struct Think: GraniteEvent {
        let security: Security
        
        public var beam: GraniteBeamType {
            .rebound
        }
        
        public struct Result: GraniteEvent {
            let sounds: [TonalSound]
            let security: Security
            
            public var beam: GraniteBeamType {
                .rebound
            }
        }
    }
    
    public struct GetSentiment: GraniteEvent {
        let range: TonalRange
        let inComplete: Bool
        
        public init(range: TonalRange, inComplete: Bool = false)//730 = 2 years - 1825 = 5 years
        {
            self.range = range
            self.inComplete = inComplete
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct ProcessSentiment: GraniteEvent {
        let sinceDate: Date
        let untilDate: Date
        let ticker: String
    }
    
    public struct TonalHistory: GraniteEvent {
        let data: [TonalServiceModels.Tweets]
        
        public init(data: [TonalServiceModels.Tweets])//730 = 2 years - 1825 = 5 years
        {
            self.data = data
        }
        
        public var async: DispatchQueue? {
            DispatchQueue.global(qos: .utility)
        }
    }
    
    public struct TonalSounds: GraniteEvent {
        let sounds: [TonalSound]
    }
    
    public struct History: GraniteEvent {
        let sentiment: TonalSentiment
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
}
