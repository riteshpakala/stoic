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

        
        guard let router = connection.retrieve(\EnvironmentDependency.router) else {
            print("{TEST} holdings does not have router")
            return
        }
        
        router?.request(.securityDetail(.init(object: event.security)))
        print("{TEST} holdings has router")
    }
}
