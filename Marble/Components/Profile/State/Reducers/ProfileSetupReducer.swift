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

        state.subscriptionUpdated = false
        
        guard let user = Auth.auth().currentUser else {
            state.user = nil
            state.userProperties = .init(
                accountAge: 0,
                stockSearches: [],
                stockPredictions: [],
                stockModels: [])
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
            
            print("{PROFILE} got the data")
            let stockSearches = data.compactMap {
                SearchStock.initialize(from: $0) }
                
                componentToPass.sendEvent(
                ProfileEvents.ProfileSetupOverView.init(
                    stockSearches: stockSearches,
                    stockPredictions: []))
                
                //david.. //DEV:
//            componentToPass
//                .service.center
//                .backend
//                .get(
//                route: .global,
//                server: .prediction,
//                key: user.uid) { data in
//
//                let stockPredictions = data.compactMap {
//                    PredictionUpdate.initialize(from: $0) }
//
//                    componentToPass.sendEvent(
//                        ProfileEvents.ProfileSetupOverView.init(
//                            stockSearches: stockSearches,
//                            stockPredictions: stockPredictions))
//            }
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
        

        print("{PROFILE} lets setup the overview \(Auth.auth().currentUser == nil)")
        guard let user = Auth.auth().currentUser else { return }
        
        let diffInDays = Calendar.nyCalendar.dateComponents(
            [.day],
            from: user.metadata.creationDate ?? Date(),
            to: Date()).day ?? 0
        
        let modelObjects: [StockModelObject] = component.service.center.getStockModels(from: .main) ?? []
        
        let models = modelObjects.map({ StockModel.init(from: $0) })
        
        state.userProperties = .init(
            accountAge: diffInDays,
            stockSearches: event.stockSearches,
            stockPredictions: event.stockPredictions,
            stockModels: models)
        
        state.recentPrediction = event.stockPredictions.first
        
        //david.. //DEV:
        state.userProperties?.isPrepared = true

        let isRequesting = component.service.center.requestSubscriptionUpdate()
        
        if (!isRequesting && state.intent == .relogin) {
            state.subscriptionUpdated = true
        }
        
        //david.. //DEV:
//        guard let stockKit = (component as? ProfileComponent)?.stockKit else {
//            print("{PROFILE} stockKit fetch failed")
//            return
//        }
//
//        print("[StockKit] {Profile} is about to prepare \(event.stockPredictions.count)")
//        stockKit.prepare()
    }
}

//struct ProfileSetupStockKitPreparedReducer: Reducer {
//    typealias ReducerEvent = StockKitEvents.StockKitIsPrepared
//    typealias ReducerState = ProfileState
//
//    func reduce(
//        event: ReducerEvent,
//        state: inout ReducerState,
//        sideEffects: inout [EventBox],
//        component: inout Component<ReducerState>) {
//
//        guard let stockKit = (component as? ProfileComponent)?.stockKit else {
//            print("[StockKit] {PROFILE} stockKit fetch failed")
//            return
//        }
//
//        if  let prediction = state.recentPrediction,
//            let symbolName = prediction.stock.symbolName {
//            print("{PROFILE} get CSV")
//            stockKit.getCSV(
//                forTicker: symbolName,
//                date: .init(prediction.thisTradingDay))
//        }
//    }
//}
//
//struct ProfileGetCSVResultsResponseReducer: Reducer {
//    typealias ReducerEvent = StockKitEvents.CSVDownloadCompleted
//    typealias ReducerState = ProfileState
//
//    func reduce(
//        event: ReducerEvent,
//        state: inout ReducerState,
//        sideEffects: inout [EventBox],
//        component: inout Component<ReducerState>) {
//
//        //david.. //DEV:
//        //lmao
//        //
//        guard let stock = event.result.first,
//              let userProperties = state.userProperties else {
//
//                print("{PROFILE} get CSV failed \(event.result.first == nil) \(state.userProperties == nil)")
//            return
//        }
//
//        print("{PROFILE} lets setup the csv dl ")
//        if userProperties
//            .stockPredictionsTradingDayResults[stock.symbolName] != nil {
//            userProperties
//            .stockPredictionsTradingDayResults[stock.symbolName]?[stock.dateData.asString] = stock
//        } else {
//            userProperties.stockPredictionsTradingDayResults[stock.symbolName] = [stock.dateData.asString:stock]
//        }
//
//        state.userProperties = userProperties
//
//        guard userProperties.totalUniques != userProperties.totalUniquesOfResults else {
//            print("{PROFILE} lets setup the csv dl 2")
//            userProperties.isPrepared = true
//            state.userProperties = userProperties
//            return
//        }
//
//        print("{PROFILE} lets setup the csv dl 3")
//
//        guard let stockKit = component.getSubComponent(
//            StockKitComponent.self) as? StockKitComponent else {
//            return
//        }
//
//        print("{PROFILE} lets setup the csv dl 4")
//
//        var symbolName: String = ""
//        var dayToGet: String = ""
//        for ticker in userProperties.uniqueTradingDaysForSymbols.keys {
//            if let days = userProperties.uniqueTradingDaysForSymbols[ticker] {
//                for day in days {
//                    if let daysResults = userProperties.stockPredictionsTradingDayResults[ticker] {
//                        if daysResults.keys.contains(day) {
//                            return
//                        } else {
//                            symbolName = ticker
//                            dayToGet = day
//                            break
//                        }
//                    } else {
//                        symbolName = ticker
//                        dayToGet = day
//                        break
//                    }
//                }
//
//                if !symbolName.isEmpty && !dayToGet.isEmpty {
//                    break
//                }
//            }
//        }
//
//        if !symbolName.isEmpty && !dayToGet.isEmpty {
//            stockKit.getCSV(
//                forTicker: symbolName,
//                date: .init(dayToGet))
//        } else {
//            print("{PROFILE} lets setup the csv dl 5")
////            userProperties.isPrepared = true
////            state.userProperties = userProperties
//            return
//        }
//    }
//}

struct ProfileResetOnboardingReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ResetOnboarding
    typealias ReducerState = ProfileState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        for item in GlobalDefaults.onboardingDefaults {
            item.update(false)
        }
        
        component.push(
            AnnouncementBuilder.build(
                component.service,
                state: .init(displayType: .alert("onboarding has been reset. Restart the app to view the tutorial again"))), display: .modalTop)
    }
}
