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
    typealias ExpeditionEvent = AssetGridItemContainerEvents.AssetTapped
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let user = connection.retrieve2(\EnvironmentDependency2.user) else {
            return
        }
        guard let security = event.asset.asSecurity else { return }
        
        switch state.context {
        case .portfolio:
            if state.addToPortfolio {
                security.addToPortfolio(username: user.info.username,
                                        moc: coreDataInstance) { portfolio in
                    if let portfolio = portfolio {
                        GraniteLogger.info("adding to portfolio:\n\(portfolio.holdings.securities.map { $0.name })", .expedition, focus: true)
                        connection.update2(\EnvironmentDependency2.user.portfolio,
                                          value: portfolio)
                    }
                }
            } else {
                guard let router = connection.router else { return }
                
                connection.update2(\EnvironmentDependency2.tonalModels.type,
                                  value: .specified(security))
                router.request(Route.securityDetail(.init(object: security)))
            }
        case .floor:
            guard let floorStage = connection.retrieve2(\EnvironmentDependency2.floorStage) else { return }
            let location: CGPoint
            if case let .adding(point) = floorStage {
                location = point
            } else {
                location = .zero
            }
            
            
            security.addToFloor(username: user.info.username,
                                location: location,
                                moc: coreDataInstance) { portfolio in
                if let portfolio = portfolio {
                    
                    GraniteLogger.info("adding to floor:\n\(portfolio.holdings.securities.map { $0.name })", .expedition, focus: true)
                    
                    connection.update2(\EnvironmentDependency2.user.portfolio,
                                      value: portfolio)
                }
            }
        default:
            break
        }
    }
}

struct HoldingSelectionsConfirmedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.AssetsSelected
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let portfolio = connection.retrieve2(\EnvironmentDependency2.user.portfolio),
              let securities = portfolio?.holdings.securities else {
            return
        }
        
        switch state.context {
        case .strategy:
            let selections = securities.filter({ event.assetIDs.contains($0.assetID) })
            portfolio?.addToStrategy(selections, moc: coreDataInstance) { portfolio in
                connection.update2(\EnvironmentDependency2.user.portfolio,
                                  value: portfolio)
            }
            break
        default:
            break
        }
    }
}
