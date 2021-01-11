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
    typealias ExpeditionEvent = AssetGridItemContainerEvents.SecurityTapped
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        switch state.context {
        case .portfolio:
            guard let router = connection.retrieve(\EnvironmentDependency.router) else {
                print("{TEST} holdings does not have router")
                return
            }
            
            router?.request(.securityDetail(.init(object: event.security)))
            print("{TEST} holdings has router")
        case .floor:
            let location: CGPoint
            if case let .adding(point) = state.floorStage {
                location = point
            } else {
                location = .zero
            }
            event.security.addToFloor(location: location, moc: coreDataInstance) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\EnvironmentDependency.user.portfolio,
                                      value: portfolio)
                }
            }
            
            print("{TEST} holdings added to Floor")
        default:
            break
        }
    }
}
