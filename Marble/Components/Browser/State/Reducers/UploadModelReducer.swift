//
//  UploadModelReducerReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 12/12/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct UploadModelReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.UploadModel
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let model = event.model, let data = model.model?.archived else { return }
        
        guard let recentStock = model.consoleDetailPayload?.historicalTradingData.sorted(
            by: {
                ($0.dateData.asDate ?? Date())
                    .compare(($1.dateData.asDate ?? Date())) == .orderedDescending

        }).first else { return }
        
        var dataSets: [String:[Double]] = [:]
            
        for type in StockKitModels.ModelType.allCases {
            let dataSet = StockKitUtils.Models.DataSet(
                recentStock,
                .neutral,
                modelType: type,
                updated: true)
            
            dataSets["\(type)"] = dataSet.asArray
        }
        
        let encoder = JSONEncoder()
        guard let dataForDataSets = try? encoder.encode(dataSets) else {
            return
        }
        
        var info: [String: String] = [:]
        
        info["nextTradingDate"] = model.tradingDay
        info["daysTrained"] = String(model.days)
        info["sentimentStrength"] = "\((model.sentiment ?? .none)?.asString ?? "error")"
        
        guard let dataForInfo = try? encoder.encode(info) else {
            return
        }
        
        let componentToPush = component
        component.service.center
            .backend
            .putData(
            data,
            filename: "model",
            key: model.stock.symbol+"/"+model.id,
            storage: .models) { successModel in

            if successModel {
                componentToPush.service.center
                    .backend
                    .putData(
                    dataForDataSets,
                    filename: "dataSet",
                    key: model.stock.symbol+"/"+model.id,
                    storage: .models) { successDataSet in
                        if successDataSet {
                            componentToPush.service.center
                                .backend
                                .putData(
                                dataForInfo,
                                filename: "metadata",
                                key: model.stock.symbol+"/"+model.id,
                                storage: .models) { success in
                                    if success {
                                        print("{SUBSCRIBE} uploaded successfully")
                                    }
                                     
                                }
                        }
                         
                    }
            }
        }
    }
}
