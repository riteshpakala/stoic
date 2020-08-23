//
//  SearchEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SearchEvents {
    struct GenerateStockRotation: Event {
    }
    
    struct GenerateStockRotationResponse: Event {
        let stocks: [SearchStock]
    }
    
    struct GetSearchResults: Event {
        let term: String
    }
    
    struct SearchUpdateAppearance: Event {
        let intentToDismiss: Bool
        public init(intentToDismiss: Bool = false) {
            self.intentToDismiss = intentToDismiss
        }
    }
}
