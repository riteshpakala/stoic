//
//  MoversSecurityExpeditionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct MoversSecurityExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.UpdateSecurities
    typealias ExpeditionState = AssetGridItemContainerState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    }
}
