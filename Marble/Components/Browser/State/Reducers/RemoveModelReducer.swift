//
//  RemoveModelReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/11/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct RemoveModelReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.RemoveModel
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard !event.id.isEmpty else { return }
        
        let dataSource = (component.viewController as? BrowserViewController)?.dataSource
        let moc = dataSource?.controller.managedObjectContext ?? component.service.center.coreData.main
        var objects: [StockModelObject] = []
        var mergeObjects: StockModelMergedObject? = nil
        do {
            if dataSource?.controller.fetchedObjects == nil {
                objects = try moc.fetch(StockModelObject.request())
            } else {
                let merged = dataSource?.controller.fetchedObjects
                let foundMerge = merged?.first(where: { ($0.models?.filter({ (($0 as? StockModelObject)?.id == event.id) }).count) ?? 0 > 0 })
                mergeObjects = foundMerge
                if let models = foundMerge?.models {
                    for model in models {
                        if let stockModelObj = model as? StockModelObject {
                            objects.append(stockModelObj)
                        }
                    }
                }
            }
        } catch let error {
            print("{BROWSER} \(error)")
        }
        
        let object = objects.first(where: {

            return $0.id == event.id

        })
        
        guard object != nil else { return }

        moc.perform {
            mergeObjects?.removeFromModels(object!)
            moc.delete(object!)
            do {
                try moc.save()
            } catch let error {
                print ("{BROWSER} \(error.localizedDescription)")
            }
        }
    }
}
