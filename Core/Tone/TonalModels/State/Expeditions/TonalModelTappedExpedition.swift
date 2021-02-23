//
//  TonalModelTappedExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/12/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct TonalModelTappedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.AssetTapped
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let model = event.asset.asModel else { return }
        let security = model.latestSecurity
        guard let router = connection.router else {
            return
        }
        
        switch router.route.convert(to: Route.self) {
        case .securityDetail:
            connection.update(\EnvironmentDependency.detail.modelID, value: model.assetID)
        default:
            connection.update(\EnvironmentDependency.detail.modelID, value: model.assetID)
            connection.update(\EnvironmentDependency.tonalModels.type, value: .specified(security))
            router.request(Route.securityDetail(.init(object: security)))
        }
    }
}
