//
//  UpdateSettingsReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/22/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct GenerateSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.GenerateSettings
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let settingsItems: [TongueSettingsModel] = GlobalDefaults.instance.writeableDefaults.map {
            
            TongueSettingsModel.init(
                help: $0.description,
                label: $0.key,
                value: $0.asString,
                selector: DashboardEvents.UpdateSettings(label: $0.key),
                reference: $0)
            
        }
        
        state.settingsItems = settingsItems
        state.settingsDidUpdate = state.settingsDidUpdate % 12
    }
}

struct UpdateSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.UpdateSettings
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let settingsItem = GlobalDefaults
            .instance
            .writeableDefaults
            .first(where: { $0.key == event.label }) else {
            
            return
        }
        
        let settingsItemCases = settingsItem.allCases
        
        guard let baseIndex = settingsItemCases.firstIndex(
            where: { $0.intValue == settingsItem.intValue }) else {
                
            return
        }
        
        let targetIndex = settingsItemCases.index(after: baseIndex)

        let targetSettingsItem = settingsItemCases[targetIndex >= settingsItemCases.count ? 0 : targetIndex]
        component.service.storage.update(targetSettingsItem)

        //Update State
        guard let indexOfSettingsItem = state.settingsItems?.firstIndex(
            where: { $0.label == event.label }) else {

            return
        }
        
        state.settingsItems?[indexOfSettingsItem].reference = targetSettingsItem
        state.settingsItems?[indexOfSettingsItem].value = targetSettingsItem.asString
        
        state.settingsDidUpdate = state.settingsDidUpdate % 12
        
    }
}
