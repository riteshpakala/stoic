//
//  HoldingSelectedExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct HoldingSelectedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridEvents.AssetTapped
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        guard let security = event.asset.asSecurity else { return }
        
        switch state.context {
        case .portfolio:
            if state.addToPortfolio {
                let portfolio = security.addToPortfolio(username: user.info.username,
                                        moc: coreDataInstance)
                if let portfolio = portfolio {
                    GraniteLogger.info("adding to portfolio:\n\(portfolio.holdings.securities.map { $0.name })", .expedition, focus: true)
                    connection.update(\EnvironmentDependency.user.portfolio,
                                      value: portfolio)
                }
            } else {
                guard let router = connection.retrieve(\RouterDependency.router) else { return }
                
                connection.update(\EnvironmentDependency.tonalModels.type,
                                  value: .specified(security))
                router.request(Route.securityDetail(.init(object: security)))
            }
        case .floor:
            guard let floorStage = connection.retrieve(\EnvironmentDependency.floorStage) else { return }
            let location: CGPoint
            if case let .adding(point) = floorStage {
                location = point
            } else {
                location = .zero
            }
            
            
            let portfolio = security.addToFloor(username: user.info.username,
                                location: location,
                                moc: coreDataInstance)
            if let portfolio = portfolio {
                
                GraniteLogger.info("adding to floor:\n\(portfolio.holdings.securities.map { $0.name })", .expedition, focus: true)
                
                connection.update(\EnvironmentDependency.user.portfolio,
                                  value: portfolio)
            }
        default:
            break
        }
    }
}

struct HoldingSelectionsConfirmedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridEvents.AssetsSelected
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio),
              let securities = portfolio?.holdings.securities else {
            return
        }
        
        switch state.context {
        case .strategy:
            let selections = securities.filter({ event.assetIDs.contains($0.assetID) })
            let updatedPortfolio = portfolio?.addToStrategy(selections, moc: coreDataInstance)
            connection.update(\EnvironmentDependency.user.portfolio,
                              value: updatedPortfolio)
            
            if let strategyName = updatedPortfolio?.strategies.first,
               let strategy = coreDataInstance.getStrategy(strategyName) {
                connection.update(\StrategyDependency.strategy, value: strategy)
            }
            
            break
        default:
            break
        }
    }
}
