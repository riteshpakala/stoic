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
        
        guard let quote = tone.find.quote else {
            GraniteLogger.error("saving tonal model failed - no quote\nself:\(self)",
                                .expedition)
            return
        }
        
        let daysTrained = tone.find.daysSelected
        let tuners = Array(tone.tune.tuners.map { $0.value.slider.sentiment })
        let range = tone.selectedRange?.dates ?? []
        
        GraniteLogger.info("compiling tonal model\nself:\(self)", .expedition)
        
        connection.update(\EnvironmentDependency.tone.compile.state, value: .compiling)
        
        TonalModels.generate(tone: tone, moc: coreDataInstance) { model in
            if let model = model {
                connection.update(\EnvironmentDependency.tone.compile.state, value: .compiled)
                connection.update(\EnvironmentDependency.tone.compile.model, value: model)
                
                let tonalModel: TonalModel = .init(model,
                                                   daysTrained: daysTrained,
                                                   tuners: tuners,
                                                   quote: quote,
                                                   range: range)
                
                connection.update(\EnvironmentDependency.tone.compile.tonalModel, value: tonalModel)
            }
        }
    }
}
