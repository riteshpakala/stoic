//
//  BaseModelSelectedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct BaseModelSelectedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.BaseModelSelected
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let model = event.model else {
            return
        }
        
        if state.compiledModelCreationData?.baseModel.id == event.model?.id {
            state.compiledModelCreationData = nil
        } else {
            state.compiledModelCreationData = .init(baseModel: model, baseModelIndexPath: event.indexPath)
            
            let stockSymbol = event.model?.stock.symbol
            let stockExchange = event.model?.stock.exchangeName
            if  let stockModel = event.model,
                let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) {
                
                state.compiledModelCreationData?.compatibleModels =
                    mergedModel.calculateCompatibleModels(from: [], base: stockModel)
            }
        }
    }
}

struct ModelToMergeReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.ModelToMerge
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let modelDay: String = event.model.tradingDay

        let stockSymbol = state.compiledModelCreationData?.baseModel.stock.symbol
        let stockExchange = state.compiledModelCreationData?.baseModel.stock.exchangeName
        
        guard  let baseStock = state.compiledModelCreationData?.baseModel,
               let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) else {
                
            return
        }
        
        if let data = state.compiledModelCreationData {
            if let mergedStocks = state.compiledModelCreationData?.modelsToMerge,
               data.modelsToMerge.keys.contains(modelDay),
               let modelData = data.modelsToMerge[modelDay],
               modelData.model.id == event.model.id {
                
                let isBaseStockGreater = (baseStock.tradingDayDate).compare(event.model.tradingDayDate) == .orderedDescending
                //TODO:****** MAX AND MIN INSTEAD OF BASE, for update only, maybe not necessery
                let datesToRemove = Array(mergedStocks.keys).filter {
                    
                    if isBaseStockGreater {
                        return ($0.asDate() ?? Date()).compare(event.model.tradingDayDate) == .orderedAscending
                    } else {
                        return ($0.asDate() ?? Date()).compare(event.model.tradingDayDate) == .orderedDescending
                    }
                }
                
                for date in datesToRemove+[modelDay] {
                    if state.compiledModelCreationData?.modelsToMerge.keys.contains(date) == true{
                        state.compiledModelCreationData?.modelsToMerge.removeValue(forKey: date)
                    }
                }
            
                let mergedStocks: [StockModel] = state.compiledModelCreationData?.modelsToMerge.values.compactMap({ $0.model }) ?? []
                
                state.compiledModelCreationData?.compatibleModels = mergedModel.calculateCompatibleModels(from: mergedStocks, base: baseStock)
            } else {
                state.compiledModelCreationData?.modelsToMerge[modelDay] = .init(event.model, event.indexPath)
                
                
                guard let mergedStocks = state.compiledModelCreationData?.modelsToMerge.values.map({ $0.model }) else {
                    return
                }
                
                state.compiledModelCreationData?.compatibleModels = mergedModel.calculateCompatibleModels(from: [event.model]+mergedStocks, base: baseStock)
            }
        }
    }
}

struct StandaloneModelSelectedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.StandaloneModelSelected
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        sideEffects.append(
            .init(event: DashboardEvents.ShowDetail.stored(
                event.model),
                  bubbles: true))
        
//        let dataForDavid = DataSet(
//            dataType: .Regression,
//            inputDimension: StockKitUtils.inDim,
//            outputDimension: StockKitUtils.outDim)
//
//        do {
//            if let dataSet = model.dataSet {
//                print("{SVM} labels \(dataSet.labels.count)")
//                for i in 2..<dataSet.labels.count {
//                    print("{SVM} \(dataSet.labels[i]) input \(dataSet.inputs[i]) ~ output \(dataSet.outputs?[i])")
//                    try dataForDavid.addDataPoint(
//                        input: dataSet.inputs[i],
//                        output: dataSet.outputs?[i] ?? [],
//                        label: dataSet.labels[i])
//                }
//            }
//        } catch let error {
//            print("{SVM} \(error)")
//        }
//
//        let time = CFAbsoluteTimeGetCurrent()
//        let david = SVMModel(
//                problemType: .ϵSVMRegression,
//                kernelSettings:
//                KernelParameters(type: .Polynomial,
//                                 degree: 3,
//                                 gamma: 0.3,
//                                 coef0: 0.0))
////        david.delegate = self
//        david.Cost = 1e3
//        david.train(data: dataForDavid)

//        let main = component.service.center.coreData.main
//        var objects: [StockModelObject] = []
//        do {
//
//            objects = try main.fetch(StockModelObject.request())
//        } catch let error {
//            print("{SVM} \(error)")
//        }
//        var object = objects.first(where: {
//
//            print("{SVM} \($0.id) == \(event.model.id)")
//
//            return $0.id == event.model.id
//
//        })
//
//        do {
//            guard object?.historicalTradingData.asStockData?.first?.averages?.sma20 == nil else {
//                return
//            }
//            print("{SVM} deleted")
//            main.delete(object!)
//            try main.save()
//        } catch let error {
//            print ("{SVM} \(error.localizedDescription)")
//        }
//
//        print("{SVM} \(object?.predictionDays) training complete \(CFAbsoluteTimeGetCurrent() - time)")
        
        
    }
}

struct MergedModelSelectedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.MergeModelSelected
    typealias ReducerState = BrowserState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        if event.lifecycle == .isReady {
            sideEffects.append(
                .init(event: DashboardEvents.ShowDetail.stored(
                    event.model.asModel),
                      bubbles: true))
        } else if event.lifecycle == .needsSyncing,
            let stock = event.model.stock.asSearchStock,
            let objectDate = event.model.date,
            let targetDate = state.nextValidTradingDay.asDate() {
            
//            let stockModelMerged: StockModelMerged = .init(from: event.model)
            
            let components = Calendar.nyCalendar.dateComponents(
                [.day],
                from: objectDate,
                to: targetDate)
            
            guard let stockKit = (component as? BrowserComponent)?.stockKit,
                let tradingDays = stockKit.state.validTradingDays?.descending,
                let lastTradingDay = tradingDays.first?.asDate else {
                return
            }
            
//            let componentsLast = Calendar.nyCalendar.dateComponents(
//                [.day],
//                from: objectDate,
//                to: lastTradingDay)
            
            let componentDiffOfValidAndTarget = Calendar.nyCalendar.dateComponents(
                [.day],
                from: lastTradingDay,
                to: targetDate)
            
            //if this does not pass, make sure stockKit's testable flag is set to `false`
            //haha
            
            if let objectAge = components.day,
                let tradingDayAge = componentDiffOfValidAndTarget.day {
                
                
                guard let updatePredictionDays = GlobalDefaults.PredictionDays.init(rawValue: objectAge - tradingDayAge) else { return }
                
                component.service.storage.update(updatePredictionDays)
                
                sideEffects.append(
                    .init(event: DashboardEvents.ShowDetail.search(stock),
                          bubbles: true))
            }

            
//            let componentsLast = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: minStock.lastStock?.dateData.asDate ?? minDate)
            
        }
    }
}
