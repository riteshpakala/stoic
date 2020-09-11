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
    public enum ShowDetail: Event {
        case search(SearchStock)
        case stored(StockModel)
    }
    
    public struct DetailIsInteracting: Event {
        let id: String
    }
    
    public struct SettingsIsInteracting: Event {}
    
    struct CloseDetail: Event {
        let id: String?
        let searchedStock: SearchStock
    }
    
    struct AllDetailsClosed: Event {
    }
    
    struct GenerateSettings: Event {
    }
    
    struct UpdateSettings: Event {
        let label: String
    }
    
    struct OpenProfile: Event {
    }
    
    struct OpenBrowser: Event {
    }
    
    struct DismissProfile: Event {
    }
}
