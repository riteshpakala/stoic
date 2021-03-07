//
//  UpdateHoldingsExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/23/21.
//

import GraniteUI
import Foundation
import Combine

struct UpdateHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = HoldingsEvents.Update
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.stage != .updating else {
            return
        }
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio) else {
            return
        }
        
        guard let holdings = portfolio?.holdings else { return }
        
        state.securitiesToSync = holdings.securities.filter { $0.isNotLatest }.map { $0 }
        
        connection.request(HoldingsEvents.Push())
        
        state.stage = .updating
        
        GraniteLogger.info("Starting to Update Portfolio - Syncing \(state.securitiesToSync.count) securities", .expedition, focus: true)
    }
}

struct PushUpdateHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = HoldingsEvents.Push
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.syncTimer?.invalidate()
        state.syncTimer = nil
        
        guard let security = state.securitiesToSync.first(where: { !state.securitiesSynced.contains($0.assetID) }) else {

            connection.request(HoldingsEvents.UpdateComplete())

            return
        }

        state.syncTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in

            timer.invalidate()

            GraniteLogger.info("Pushing \(security.assetID) to Sync\n \(security.updateTime) days old\n\(String(describing: self))", .expedition, focus: true)

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

struct UpdateCompleteHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = HoldingsEvents.UpdateComplete
    typealias ExpeditionState = HoldingsState
    
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
        
        connection.update(\EnvironmentDependency.user, value: user, .home)
        connection.request(HoldingsEvents.Get())

        GraniteLogger.info("set user after Portfolio sync", .expedition, focus: true)
    }
}

struct StockUpdatedHistoryHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let stocks = event.data
        
        _ = stocks.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(stocks.first?.assetID ?? "")
        
        GraniteLogger.info("Portfolio Update Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(HoldingsEvents.Push())
    }
}

struct CryptoUpdatedHistoryHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let crypto = event.data
        
        _ = crypto.save(moc: coreDataInstance)
        
        state.securitiesSynced.append(crypto.first?.assetID ?? "")
        
        GraniteLogger.info("Portfolio Update Progress \(state.syncProgress)", .expedition, focus: true)
        
        connection.request(HoldingsEvents.Push())
    }
}
