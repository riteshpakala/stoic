//
//  SearchSecurityExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import GraniteUI
import SwiftUI
import Combine

struct SearchAssetExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SearchEvents.Result
    typealias ExpeditionState = AssetSearchState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} yoooo")
        state.payload = .init(object: event.securities)
    }
}
