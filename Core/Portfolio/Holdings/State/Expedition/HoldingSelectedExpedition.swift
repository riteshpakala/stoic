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
        
        guard let security = event.asset.asSecurity else { return }
        switch state.context {
        case .portfolio:
            guard let router = connection.retrieve(\EnvironmentDependency.router) else {
                return
            }
            connection.update(\EnvironmentDependency.tonalModels.type,
                              value: .specified(security))
            router?.request(.securityDetail(.init(object: security)))
            
        case .floor:
            let location: CGPoint
            if case let .adding(point) = state.floorStage {
                location = point
            } else {
                location = .zero
            }
            security.addToFloor(location: location, moc: coreDataInstance) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\EnvironmentDependency.user.portfolio,
                                      value: portfolio)
                }
            }
            
        default:
            break
        }
    }
}
