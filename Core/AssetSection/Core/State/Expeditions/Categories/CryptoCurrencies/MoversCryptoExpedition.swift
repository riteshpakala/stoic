//
//  TopVolumeCryptoExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/21/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct MoversCryptoExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GlobalCategoryResult
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} heard")
        state.securityData = event.topVolume
        state.payload = .init(object: state.securityData)
    }
}
