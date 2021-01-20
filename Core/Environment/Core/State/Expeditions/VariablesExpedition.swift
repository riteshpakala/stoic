//
//  VariablesExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/19/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct VariablesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.Variables
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    }
}
