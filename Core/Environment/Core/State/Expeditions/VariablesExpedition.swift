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
        
        guard var envSettings = connection.retrieve(\RouterDependency.environment.envSettings) else {
            return
        }
        
        if envSettings.lf == nil {
            let newLF = EnvironmentStyle.Settings.LocalFrame.init(data: state.localFrame ?? .zero)
            envSettings.lf = newLF
            connection.update(\RouterDependency.environment.envSettings, value: envSettings, .here)
        } else {
            state.localFrame = envSettings.lf?.data
        }
        
    }
}
