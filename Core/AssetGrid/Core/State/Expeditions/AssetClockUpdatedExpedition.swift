//
//  AssetClockUpdatedExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct AssetClockUpdatedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridEvents.ClockUpdated
    typealias ExpeditionState = AssetGridState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} as well as me \(state.count)")
        state.count += 1
    }
}
