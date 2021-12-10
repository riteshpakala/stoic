//
//  TonalCreatePrepare.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/7/21.
//

import Foundation
import GraniteUI
import Combine

struct PrepareTonalCreateExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCreateEvents.Prepare
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let tone = connection.retrieve(\ToneDependency.tone) else {
            return
        }
        
        tone.loading(state.stage, component: event.component)
    }
}
