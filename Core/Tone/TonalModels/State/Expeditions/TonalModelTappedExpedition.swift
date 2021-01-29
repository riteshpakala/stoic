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
        guard let router = connection.retrieve(\EnvironmentDependency.router) else {
            return
        }
        
        switch router?.route {
        case .securityDetail:
            connection.update(\EnvironmentDependency.detail.model, value: model)
        default:
            connection.update(\EnvironmentDependency.tonalModels.type, value: .specified(security))
            router?.request(.securityDetail(.init(object: security)))
        }
    }
}
