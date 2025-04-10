//
//  MergeModelReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct MergeModelReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.MergeModel
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.isCompiling = true
        print("{Browser} merging model")
        
        let stock: StockModel?
        let merging: [StockModel]
        switch event.intent {
        case .creation:
            guard let baseStock = state.compiledModelCreationData?.baseModel else {
                stock = nil
                merging = []
                state.isCompiling = false
                return
            }
            
            guard let modelsToMerge = state.compiledModelCreationData?.modelsToMerge else {
                stock = nil
                merging = []
                state.isCompiling = false
                return
            }
            
            guard state.mergedModels.first(where: { $0.stock.symbol == baseStock.stock.symbol && $0.stock.exchangeName == baseStock.stock.exchangeName }) != nil else {
                stock = nil
                merging = []
                state.isCompiling = false
                return
            }
            
            stock = baseStock
            merging = (modelsToMerge.values.map({ $0.model })) + [baseStock]
        case .deletion(_):
            //TODO: [WIP] deleting a model that is in a merged model
            stock = nil
            merging = []
            state.isCompiling = false
            break
//            guard let baseStock = stockModel else {
//                stock = nil
//                merging = []
//                state.isCompiling = false
//                return
//            }
//
//            guard let mergeModel = state.mergedModels.first(where: { $0.stock.symbol == baseStock.stock.symbol && $0.stock.exchangeName == baseStock.stock.exchangeName }) else {
//                stock = nil
//                merging = []
//                state.isCompiling = false
//                return
//            }
//
//            let newModels = mergeModel.mergedStocks.filter { $0.id == baseStock.id }
//
//            guard !newModels.isEmpty else {
//                stock = nil
//                merging = []
//                state.isCompiling = false
//                if let mergeModelIndex = state.mergedModels.firstIndex(where: { $0.stock.symbol == baseStock.stock.symbol && $0.stock.exchangeName == baseStock.stock.exchangeName }) {
//
//                    state.mergedModels.remove(at: mergeModelIndex)
//                }
//                return
//            }
//
//            stock = baseStock
//            merging = newModels
        }
        
        guard !merging.isEmpty, let baseStock = stock else {

            state.isCompiling = false
            return }
        
        let allModelsToMerge = merging.sorted(by: {
            ($0.tradingDayDate)
                .compare($1.tradingDayDate) == .orderedAscending })
        
        
        let componentToPass = component
        DispatchQueue.merge.async {
            
            let david = StockKitModels.merge(modelObjects: allModelsToMerge)
            
            //Merged model
            
            let modelIDs: [String] = allModelsToMerge.map { $0.id }
            guard let vc = componentToPass.viewController as? BrowserViewController else {
                return
            }
            let moc = vc.dataSource?.controller.managedObjectContext
            guard let mergedObject: StockModelMergedObject = vc.dataSource?.controller.fetchedObjects?.first(where: {
                        $0.stock.asSearchStock?.symbol == baseStock.stock.symbol &&
                        $0.stock.asSearchStock?.exchangeName == baseStock.stock.exchangeName
                    
                }) else {
                return
            }
            
            guard let model = david.archived,
                  let modelIDsData = modelIDs.archived else {
                  return
            }
            
            moc?.perform {
                mergedObject.setValue(model, forKey: "model")
                mergedObject.setValue(modelIDsData, forKey: "currentModels")
                
                do {
                    try moc?.save()

                    componentToPass.sendEvent(
                        BrowserEvents.UpdateMergedModel.init(
                            model: mergedObject))
                } catch let error {
                    print("{SVM} \(error)")
                }
            }
        }
    
        /********
         
            numClasses = 1
         
            rho = {SVM} [-211.289993]
            {SVM} [-226.04297512324501]
         
            totalSupportVectors =  {SVM} 0
            {SVM} 3
            
            supportVector = {SVM} 2020-09-10 []
            {SVM} 2020-09-09 [[0.125, 0.0030022554599817277, 0.9944123971837314, 1.1128151232906962, 0.052, 0.191, 0.757, -0.6486], [0.09090909090909091, 0.0010341002821748298, 1.6684154696779252, 1.0438797146246144, 0.375, 0.0, 0.625, 0.6369], [0.058823529411764705, 0.0005908647242298818, 1.6699177956795397, 1.0292279142689365, 0.052, 0.191, 0.757, -0.6486]]
         
            coefficients = {SVM} 2020-09-10 [[]]
            {SVM} 2020-09-09 [[13.4688562705895, 1.0750511526176598, -14.543907423207159]]
         
            probA = {SVM} 2020-09-10 []
            {SVM} 2020-09-09 []
         
            probB = {SVM} 2020-09-10 []
            {SVM} 2020-09-09 []
         
         */
        
    }
}

struct UpdateMergedModelReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.UpdateMergedModel
    typealias ReducerState = BrowserState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
    
        
        let model = event.model
        
        if let index = state.mergedModels.firstIndex(where: { $0.id == model.id }) {
            
            state.mergedModels[index].update(from: model)
        }
        
        
        sideEffects.append(
            .init(event: BrowserEvents
                .CompiledModelCreationStatusUpdated.init(.none)))
    }

}
