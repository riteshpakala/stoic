//
//  GenerateIndicatorExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/21/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GenerateIndicatorExpedition: GraniteExpedition {
    typealias ExpeditionEvent = IndicatorDetailEvents.Generate
    typealias ExpeditionState = IndicatorDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    }
}
