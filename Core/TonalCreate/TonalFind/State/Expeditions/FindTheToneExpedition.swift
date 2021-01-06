//
//  StockHistoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct FindTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalFindEvents.Find
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
//        state.stage = .find
        print("{TEST} on appear")
        
        //DEV:
        // Need to also check for last trading day
        // update the cache from last date saved to the recent day
        // requested on
        //
        guard let ticker = event.ticker else { return }
        if let quote = coreDataInstance.getQuotes()?.first(where: { $0.ticker == ticker && $0.intervalType == SecurityInterval.day.rawValue }) {
            
            connection.dependency(\TonalCreateDependency.tone.find.quote, value: quote)
            
            connection.request(TonalFindEvents.Parse(quote, days: state.days))
        } else {
            connection.request(StockEvents.GetStockHistory.init(ticker: ticker), beam: true)
        }
    }
}

struct StockHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let stocks = event.data.first?.asStocks(interval: event.interval) else {
            return
        }
        
        stocks.save(moc: coreDataInstance) { quote in
            if let object = quote {
                connection.dependency(\TonalCreateDependency.tone.find.quote, value: object)
                connection.request(TonalFindEvents.Parse(object, days: state.days))
            }
        }
    }
}


//
    
//    func save(data: [StockData]) {
//        let moc: NSManagedObjectContext
//        if Thread.isMainThread {
//            moc = coreData.main
//        } else {
//            moc = coreData.background
//        }
//
//        moc.perform {
//            for stockData in data {
//                guard
//                    let archivedData = stockData.archived,
//                    let date = stockData.dateData.asDate else { return }
//
//                let stock = stockData.asStock
//
//                let object = SecurityObject.init(context: moc)
//                object.date = date
//                object.data = archivedData
//
//                stock.apply(to: object)
//            }
//
//            do {
//                try moc.save()
//                print ("{CoreData} saved")
//            } catch let error {
//                print ("{CoreData} \(error.localizedDescription)")
//            }
//        }
//    }

//    func saveStockPredictions(
//        _ prediction: StockModelObjectPayload,
//        with context: CoreDataThread) -> String? {
//
//        let moc: NSManagedObjectContext
//
//        switch context {
//        case .background:
//            moc = coreData.background
//        case .main:
//            moc = coreData.main
//        }
//
//        guard let preparedData = ServiceCenter.prepareData(from: prediction) else {
//            return nil
//        }
//
//        let uid: String = UUID.init().uuidString
//        moc.perform {
//            let mergedModels: [StockModelMergedObject]? = try? moc.fetch(StockModelMergedObject.request())
//            let mergedModel = mergedModels?.first(where: { $0.stock.asSearchStock?.symbol == prediction.stock.symbol && $0.stock.asSearchStock?.exchangeName == prediction.stock.exchangeName })
//            let merged = mergedModel ?? StockModelMergedObject.init(context: moc)
//
//            if mergedModel == nil {
//                merged.stock = preparedData.stock
//                merged.order = Int64(mergedModels?.count ?? 0)
//                merged.timestamp = Date().timeIntervalSince1970
//            }
//
//            let object = StockModelObject.init(context: moc)
//            object.model = preparedData.modelData
//            object.date = prediction.date.asDate?.timeIntervalSince1970 ?? 0.0
//            object.predictionDays = Int64(prediction.predictionDays)
//            object.sentimentStrength = Int64(prediction.sentimentStrength)
//            object.ticker = prediction.stock.symbolName ?? ""
//            object.exchange = prediction.stock.exchangeName ?? ""
//            object.sentimentTradingData = preparedData.sentimentData
//            object.historicalTradingData = preparedData.historicalData
//            object.stock = preparedData.stock
//            object.timestamp = Date().timeIntervalSince1970
//            object.id = uid
//
//            merged.addToModels(object)
//
//            do {
//                try moc.save()
//            } catch let error {
//                print ("{CoreData} \(error.localizedDescription)")
//            }
//        }
//
//        return uid
//    }
