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
        
        guard state.stage != .syncing else {
            GraniteLogger.info("already syncing strategy!", .expedition, focus: true)
            return
        }
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio),
              let strategies = portfolio?.strategies else {
            return
        }
        
        //There's only 1 strategy for now
        guard let strategy = strategies.first else {
            return
        }
        
        let securities = strategy.quotes.filter({ $0.needsUpdate }).map { $0.latestSecurity }
        
        guard securities.isNotEmpty else { return }
        
        state.securitiesToSync = securities
        
        connection.request(StrategyEvents.Push())
        
        state.stage = .syncing
        
        GraniteLogger.info("Starting to Sync Strategy", .expedition, focus: true)
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
        
        stocks.save(moc: coreDataInstance) { _ in }
        
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
        
        crypto.save(moc: coreDataInstance) { _ in }
        
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
            
        state.securitiesSynced.removeAll()
        state.securitiesToSync.removeAll()
        
        state.stage = .none
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        
        coreDataInstance.getPortfolio(username: user.info.username) { portfolio in
            user.portfolio = portfolio
            
            connection.update(\EnvironmentDependency.user, value: user, .home)
            connection.request(StrategyEvents.Get())

            GraniteLogger.info("set user after strategy sync", .expedition, focus: true)
        }
        
        GraniteLogger.info("Strategy Sync Complete", .expedition, focus: true)
    }
}
