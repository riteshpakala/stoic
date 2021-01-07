//
//  CompileTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct CompileTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCompileEvents.Compile
    typealias ExpeditionState = TonalCompileState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let tone = connection.depObject(\EnvironmentDependency.tone) else {
            return
        }
        
        connection.dependency(\EnvironmentDependency.tone.compile.state, value: .compiling)
        
        guard let model = TonalModels.generate(tone: tone, moc: coreDataInstance) else {
            return
        }
        
//        model.testPredict(tone: tone, moc: coreDataInstance)
        
        connection.dependency(\EnvironmentDependency.tone.compile.state, value: .compiled)
        connection.dependency(\EnvironmentDependency.tone.compile.model, value: model)
    }
}
