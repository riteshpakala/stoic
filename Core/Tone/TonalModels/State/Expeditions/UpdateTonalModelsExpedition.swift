//
//  UpdateTonalModelsExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/23/21.
//
import GraniteUI
import Foundation
import Combine

struct UpdateTonalModelsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.Update
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.stage != .updating else {
            return
        }
        
        guard state.tonesToSync.isNotEmpty else { return }
        
        let quotes = state.tones?.compactMap { $0.quote }.filter { $0.needsUpdate } ?? []
        
        state.securitiesToSync = quotes.map { $0.latestSecurity }
        
        connection.request(TonalModelsEvents.Push())
        
        state.stage = .updating
        
        GraniteLogger.info("Starting to Update Models - Syncing \(quotes.count) quotes", .expedition, focus: true)
    }
}

struct PushTonalModelExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.Push
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.syncTimer?.invalidate()
        state.syncTimer = nil
        
        guard let security = state.securitiesToSync.first(where: { !state.securitiesSynced.contains($0.assetID) }) else {

            connection.request(TonalModelsEvents.Train())

            return
        }

        state.syncTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in

            timer.invalidate()

            GraniteLogger.info("Pushing \(security.assetID) to Sync Quote\n \(security.updateTime) days old\n\(String(describing: self))", .expedition, focus: true)

            switch security.securityType {
            case .crypto:
                connection.request(CryptoEvents.GetCryptoHistory.init(security: security, daysAgo: security.updateTime))
            case .stock:
                connection.request(StockEvents.GetStockHistory.init(security: security, daysAgo: security.updateTime))
            default:
                break
            }
        }
    }
}

struct TrainTonalModelExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.Train
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.syncTimer?.invalidate()
        state.syncTimer = nil
        
        GraniteLogger.info("Training: \(state.tonesToSync.first(where: { !state.tonesSynced.contains($0)}))\n\(state.tonesSynced) \(state.tonesToSync)\n\(String(describing: self))", .expedition, focus: true)
        
        guard let modelToSync = state.tonesToSync.first(where: { !state.tonesSynced.contains($0) }),
              let model = state.tones?.first(where: { $0.modelID == modelToSync })
               else {

            connection.request(TonalModelsEvents.UpdateComplete())

            return
        }
        
        let security = model.latestSecurity

        state.syncTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in

            timer.invalidate()
            
            connection.request(TonalEvents.Think.init(security: security))

            GraniteLogger.info("Pushing \(security.assetID) to train, thinking first\n \(security.updateTime) days old\n\(String(describing: self))", .expedition, focus: true)

        }
    }
}

struct UpdateTonalModelCompleteExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.UpdateComplete
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
            
        state.syncTimer?.invalidate()
        state.syncTimer = nil
        state.tonesToSync.removeAll()
        state.tonesSynced.removeAll()
        state.securitiesToSync.removeAll()
        state.securitiesSynced.removeAll()
        
        state.stage = .none
        
//        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
//            return
//        }
//
//        coreDataInstance.getPortfolio(username: user.info.username) { portfolio in
//            user.portfolio = portfolio
//
//            connection.update(\EnvironmentDependency.user, value: user, .home)
//            connection.request(StrategyEvents.Get())
//
//            GraniteLogger.info("set user after strategy sync", .expedition, focus: true)
//        }
//
//        GraniteLogger.info("Strategy Sync Complete", .expedition, focus: true)
    }
}

struct ThinkTonalModelExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.Think.Result
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let security = event.security
        
        guard let modelIndex = state.tones?.firstIndex(where: { $0.latestSecurity.assetID == security.assetID && !state.tonesSynced.contains($0.modelID) }),
              let model = state.tones?[modelIndex] else {
            connection.request(TonalModelsEvents.UpdateComplete())
            GraniteLogger.info("Failed to train \(security.assetID)\n\(String(describing: self))", .expedition, focus: true)
            return
        }
        
        let quote = model.quote
        
        let soundCount = event.sounds.count.asDouble
        let sentiments = event.sounds.map { $0.sentiment }
        
        let posAvg = sentiments.map { $0.pos }.reduce(0, +).asDouble / soundCount
        let negAvg = sentiments.map { $0.neg }.reduce(0, +).asDouble / soundCount
        let neuAvg = sentiments.map { $0.neu }.reduce(0, +).asDouble / soundCount
        let compoundAvg = sentiments.map { $0.compound }.reduce(0, +).asDouble / soundCount
        
        let sentiAvg: SentimentOutput = .init(pos: posAvg, neg: negAvg, neu: neuAvg, compound: compoundAvg)
        
        GraniteLogger.info("Training \(security.assetID) with\nsenti avg: \(sentiAvg.asString) \n\(String(describing: self))", .expedition, focus: true)
        
        model.david.append(security: security, quote: quote, sentiment: sentiAvg)
        
        state.tones?[modelIndex] = model
        
        state.tonesSynced.append(model.modelID)
        
        let success = model.save(moc: coreDataInstance, overwrite: true)
        if success {
            connection.request(TonalModelsEvents.Train())
            
            GraniteLogger.info("saved new tonal model\nself:\(String(describing: self))", .expedition, focus: true)
        }
    }
}

struct StockUpdatedHistoryTonalModelExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let stocks = event.data
        
        _ = stocks.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(stocks.first?.assetID ?? "")
        
        GraniteLogger.info("Tonal Update Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(TonalModelsEvents.Push())
    }
}

struct CryptoUpdatedHistoryTonalModelExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let crypto = event.data
        
        _ = crypto.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(crypto.first?.assetID ?? "")
        
        GraniteLogger.info("Tonal Update Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(TonalModelsEvents.Push())
    }
}
