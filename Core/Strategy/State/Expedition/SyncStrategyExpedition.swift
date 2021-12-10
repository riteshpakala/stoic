//
//  GetStrategyExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/19/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct SyncStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Sync
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard !state.stage.busy else {
            GraniteLogger.info("already syncing strategy!", .expedition, focus: true)
            return
        }
        
        let assetIDs = state.strategy.investments.items.filter({ !$0.closed }).map { $0.assetID }
        let securities = state.strategy.quotes.filter({ $0.needsUpdate && assetIDs.contains($0.latestSecurity.assetID) }).map { $0.latestSecurity }
        
        guard securities.isNotEmpty else {
            connection.request(StrategyEvents.Predict())
            state.stage = .predicting
            return
        }
        
        state.securitiesToSync = securities
        
        connection.request(StrategyEvents.Push())
        
        state.stage = .syncing
        
        GraniteLogger.info("Starting to Sync Strategy", .expedition, focus: true)
    }
}

struct SyncPredictionsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Predict
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.strategy.generate()
        
        GraniteLogger.info("Starting to Sync Predictions", .expedition, focus: true)
    }
}

struct PushSecurityStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Push
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.syncTimer?.invalidate()
        state.syncTimer = nil
        
        guard let security = state.securitiesToSync.first(where: { !state.securitiesSynced.contains($0.assetID) }) else {
            
            connection.request(StrategyEvents.SyncComplete())
            
            return
        }
        
        state.syncTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in
            
            timer.invalidate()
            
            GraniteLogger.info("Pushing \(security.assetID) to Sync\n \(security.updateTime) days old", .expedition, focus: true)
            
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

struct StockUpdatedHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let stocks = event.data
        
        _ = stocks.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(stocks.first?.assetID ?? "")
        
        GraniteLogger.info("Strategy Sync Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(StrategyEvents.Push())
    }
}

struct CryptoUpdatedHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let crypto = event.data
        
        _ = crypto.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(crypto.first?.assetID ?? "")
        
        GraniteLogger.info("Strategy Sync Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(StrategyEvents.Push())
    }
}

struct SyncCompleteStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.SyncComplete
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.syncTimer?.invalidate()
        state.syncTimer = nil
            
        state.securitiesSynced.removeAll()
        state.securitiesToSync.removeAll()
        
        state.stage = .none
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        
        let portfolio = coreDataInstance.getPortfolio(username: user.info.username)
        user.portfolio = portfolio
        
        connection.update(\EnvironmentDependency.user, value: user)
        
        state.strategy = state.strategy.updated(moc: coreDataInstance) ?? state.strategy
        
        connection.update(\StrategyDependency.strategy, value: state.strategy)
        
        connection.request(StrategyEvents.Get())
        
        GraniteLogger.info("Strategy Sync Complete", .expedition, focus: true)
    }
}
