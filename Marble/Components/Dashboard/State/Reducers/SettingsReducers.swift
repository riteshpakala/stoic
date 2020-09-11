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
        
        let settingsItems: [TongueSettingsModel<LocalStorageValue>] = GlobalDefaults.instance.readableDefaults.map {
            
            let value: String
            if let resource = $0.resource {
                switch resource {
                case .image(let name):
                    value = name
                }
            } else {
                value = $0.asString
            }
            
            return TongueSettingsModel.init(
                help: $0.description,
                label: $0.key,
                value: value,
                isResource: $0.resource != nil,
                selector: DashboardEvents.UpdateSettings(label: $0.key),
                reference: $0)
            
        }
        
        state.settingsItems = settingsItems
        state.settingsDidUpdate = state.settingsDidUpdate % 12
    }
}

struct ShowSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.SettingsIsInteracting
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        if let view = component.viewController?.view as? DashboardView {
            component.viewController?.view.bringSubviewToFront(view.settings)
        }
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
            
                if event.label == GlobalDefaults.Subscription.key {
                    sideEffects.append(.init(event: DashboardEvents.OpenProfile()))
                } else if event.label == GlobalDefaults.Browser.key {
                    sideEffects.append(.init(event: DashboardEvents.OpenBrowser()))
                }
                
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

struct OpenProfileSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.OpenProfile
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        component.push(
            ProfileBuilder.build(component.service),
            display: .modal)
        
    }
}

struct OpenBrowserSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.OpenBrowser
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let mergedObjects: [StockModelMergedObject] = component.service.center.getMergedStockModels(from: .main) ?? []
        
        let modelsMerged = mergedObjects.map({ StockModelMerged.init(from: $0) })
        
        component.push(
            BrowserBuilder.build(
                component.service,
                state: .init(modelsMerged)),
            display: .modal)
    }
}

struct DismissProfileSettingsReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.DismissProfile
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        if let profile = component.getSubComponent(ProfileComponent.self) {
            component.pop(profile, animated: true)
        }
        
    }
}
