//
//  GetTonesExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/14/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GenerateTonesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalDetailEvents.Generate
    typealias ExpeditionState = TonalDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let _ = state.quote else { return }
        GraniteLogger.info("generating tonal details - quote received\nself:\(self)", .expedition)
    
    }
}
