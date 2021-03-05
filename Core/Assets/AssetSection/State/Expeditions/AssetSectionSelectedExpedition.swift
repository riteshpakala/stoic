//
//  AssetSectionSelected.swift
//  stoic (iOS)
//
//  Created by Ritesh Pakala on 2/12/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct AssetSectionSelectedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.AssetTapped
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let security = event.asset.asSecurity else { return }
        guard let router = connection.router else { return }
        connection.update2(\EnvironmentDependency2.tonalModels.type,
                          value: .specified(security))
        router.request(Route.securityDetail(.init(object: security)))
    }
}
