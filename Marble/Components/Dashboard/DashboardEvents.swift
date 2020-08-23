//
//  DashboardEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct DashboardEvents {
    struct ShowDetail: Event {
        let searchedStock: SearchStock
    }
    
    struct CloseDetail: Event {
        let id: String?
        let searchedStock: SearchStock
    }
    
    struct GenerateSettings: Event {
    }
    
    struct UpdateSettings: Event {
        let label: String
    }
}
