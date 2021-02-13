//
//  AssetSelectedExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import GraniteUI
import SwiftUI
import Combine

struct AssetSelectedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.AssetTapped
    typealias ExpeditionState = AssetSearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

//        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
//            return
//        }
//
//        switch state.context {
//        case .tonalCreate:
//            guard let security = event.asset.asSecurity else { return }
//
//            connection.update(\EnvironmentDependency.tone.find.security, value: security)
//        case .portfolio:
//            guard let security = event.asset.asSecurity else { return }
//            security.addToPortfolio(username: user.info.username,
//                                    moc: coreDataInstance) { portfolio in
//                if let portfolio = portfolio {
//                    GraniteLogger.info("\(portfolio.holdings.securities.map { $0.name })", .expedition)
//                    connection.update(\EnvironmentDependency.user.portfolio,
//                                      value: portfolio)
//                }
//            }
//        case .floor:
//            guard let security = event.asset.asSecurity else { return }
//            let location: CGPoint
//            if case let .adding(point) = state.floorStage {
//                location = point
//            } else {
//                location = .zero
//            }
//            security.addToFloor(username: user.info.username,
//                                location: location,
//                                moc: coreDataInstance) { portfolio in
//                if let portfolio = portfolio {
//                    connection.update(\EnvironmentDependency.user.portfolio,
//                                      value: portfolio)
//                }
//            }
//        case .search:
        guard state.gridType == .standard else { return }
        guard let security = event.asset.asSecurity else { return }
        guard let router = connection.router else { return }
        
        connection.update(\EnvironmentDependency.tonalModels.type,
                          value: .specified(security))
        router.request(Route.securityDetail(.init(object: security)))
//        default:
//            break
//        }
    }
}
