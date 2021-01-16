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
        
        guard let tone = connection.retrieve(\EnvironmentDependency.tone) else {
            return
        }
        
        GraniteLogger.info("compiling tonal model\nself:\(self)", .expedition)
        
        connection.update(\EnvironmentDependency.tone.compile.state, value: .compiling)
        
        TonalModels.generate(tone: tone, moc: coreDataInstance) { model in
            connection.update(\EnvironmentDependency.tone.compile.state, value: .compiled)
            connection.update(\EnvironmentDependency.tone.compile.model, value: model)
        }
    }
}
