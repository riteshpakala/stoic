//
//  ProfileSetupReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import Firebase

struct ProfileSetupReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ProfileSetup
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let user = Auth.auth().currentUser else {
            state.user = nil
            state.userProperties = .init(
                accountAge: 0,
                stockSearches: [],
                stockPredictions: [])
            
            component.service.center.updateSubscription()
            return
        }
        
        guard let userData = try? component.service.center.keychain.retrieve() else {
            return
        }
        
        state.subscription = component.service.storage.get(GlobalDefaults.Subscription.self)
        
        state.user = userData
        
        sideEffects.append(
            EventBox.init(
                event: ProfileEvents.GetDisclaimer()))
        
//
//        let diffInDays = Calendar.nyCalendar.dateComponents(
//            [.day],
//            from: user.metadata.creationDate ?? Date(),
//            to: Date()).day
        
        let componentToPass = component
        component
            .service.center
            .backend
            .get(
            route: .global,
            server: .search,
            key: user.uid) { data in
            
                
            let stockSearches = data.compactMap {
                SearchStock.initialize(from: $0) }
            componentToPass
                .service.center
                .backend
                .get(
                route: .global,
                server: .prediction,
                key: user.uid) { data in
                
                let stockPredictions = data.compactMap {
                    PredictionUpdate.initialize(from: $0) }
                
                    componentToPass.sendEvent(
                        ProfileEvents.ProfileSetupOverView.init(
                            stockSearches: stockSearches,
                            stockPredictions: stockPredictions))
            }
        }
    }
}

struct ProfileSetupOverViewReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ProfileSetupOverView
    typealias ReducerState = ProfileState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
            
        guard let user = Auth.auth().currentUser else { return }
            
        let diffInDays = Calendar.nyCalendar.dateComponents(
            [.day],
            from: user.metadata.creationDate ?? Date(),
            to: Date()).day ?? 0
            
        state.userProperties = .init(
            accountAge: diffInDays,
            stockSearches: event.stockSearches,
            stockPredictions: event.stockPredictions)
        
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        if  let prediction = event.stockPredictions.first,
            let symbolName = prediction.stock.symbolName {
            stockKit.getCSV(
                forTicker: symbolName,
                date: .init(prediction.nextTradingDay))
        }
    }
}

struct ProfileGetCSVResultsResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.CSVDownloadCompleted
    typealias ReducerState = ProfileState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let stock = event.result.first,
              let userProperties = state.userProperties else {
            return
        }
        
        if userProperties
            .stockPredictionsTradingDayResults[stock.symbolName] != nil {
            userProperties
            .stockPredictionsTradingDayResults[stock.symbolName]?[stock.dateData.asString] = stock
        } else {
            userProperties.stockPredictionsTradingDayResults[stock.symbolName] = [stock.dateData.asString:stock]
        }
        
        state.userProperties = userProperties
        
        guard userProperties.totalUniques != userProperties.totalUniquesOfResults else {
            userProperties.isPrepared = true
            state.userProperties = userProperties
            return
        }
        
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        var symbolName: String = ""
        var dayToGet: String = ""
        for ticker in userProperties.uniqueTradingDaysForSymbols.keys {
            if let days = userProperties.uniqueTradingDaysForSymbols[ticker] {
                for day in days {
                    if let daysResults = userProperties.stockPredictionsTradingDayResults[ticker] {
                        if daysResults.keys.contains(day) {
                            return
                        } else {
                            symbolName = ticker
                            dayToGet = day
                            break
                        }
                    } else {
                        symbolName = ticker
                        dayToGet = day
                        break
                    }
                }
                
                if !symbolName.isEmpty && !dayToGet.isEmpty {
                    break
                }
            }
        }
        
        if !symbolName.isEmpty && !dayToGet.isEmpty {
            stockKit.getCSV(
                forTicker: symbolName,
                date: .init(dayToGet))
        } else {
            return
        }
    }
}
