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

        guard state.context == .unassigned else { return }
        guard let security = event.asset.asSecurity else { return }
        guard let router = connection.router else { return }
        
        connection.update2(\EnvironmentDependency2.tonalModels.type,
                          value: .specified(security))
        router.request(Route.securityDetail(.init(object: security)))
    }
}
