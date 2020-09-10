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
        
        
        print("{Browser} merging model")
        
        guard let baseStock = state.compiledModelCreationData?.baseModel else {
            return
        }
        
        guard let modelsToMerge = state.compiledModelCreationData?.modelsToMerge else {
            return
        }
        
        guard let mergeModel = state.mergedModels.first(where: { $0.stock.symbol == baseStock.stock.symbol && $0.stock.exchangeName == baseStock.stock.exchangeName }) else {
            return
        }
        
        var merging = modelsToMerge.values.map({ $0.model })
        merging.append(baseStock)
        let allModelsToMerge = merging.sorted(by: {
            ($0.tradingDayDate)
                .compare($1.tradingDayDate) == .orderedAscending })
        
        
        let dataForDavid = DataSet(
            dataType: .Regression,
            inputDimension: StockKitUtils.inDim,
            outputDimension: StockKitUtils.outDim)
        
        do {
            for model in allModelsToMerge {
                if let dataSet = model.object.dataSet?.asDataSet {
                    for i in 0..<dataSet.labels.count {
                        try dataForDavid.addDataPoint(
                            input: dataSet.inputs[i],
                            output: dataSet.outputs?[i] ?? [],
                            label: dataSet.labels[i])
                    }
                }
            }
        } catch {
            print("{SVM} Invalid data set created")
        }
        
        let david = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 3,
                             gamma: 0.3,
                             coef0: 0.0))
//        david.delegate = self
        david.Cost = 1e3
        david.train(data: dataForDavid)
        
        print("{SVM} \(mergeModel.engine)")
        //Merged model
        
        
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
