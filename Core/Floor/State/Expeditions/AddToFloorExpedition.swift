//
//  AddToFloorExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct AddToFloorExpedition: GraniteExpedition {
    typealias ExpeditionEvent = FloorEvents.AddToFloor
    typealias ExpeditionState = FloorState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.update(\EnvironmentDependency.holdingsFloor.floorStage,
                          value: .adding(event.location), .here)
    }
}

struct ExitAddToFloorExpedition: GraniteExpedition {
    typealias ExpeditionEvent = FloorEvents.ExitAddToFloor
    typealias ExpeditionState = FloorState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.update(\EnvironmentDependency.holdingsFloor.floorStage,
                          value: .none,
                          .here)
    }
}
