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
        
        guard let tone = connection.retrieve(\ToneDependency.tone) else {
            GraniteLogger.error("compiling tonal model failed - no tone\nself:String(describing: self)",
                                    .expedition, focus: true)
            return
        }
        
        guard let quote = tone.find.quote else {
            GraniteLogger.error("compiling tonal model failed - no quote\nself:String(describing: self)",
                                .expedition, focus: true)
            return
        }
        
        let daysTrained = tone.find.daysSelected
        let tuners = Array(tone.tune.tuners.map { $0.value.slider.sentiment })
        let range = tone.selectedRange?.dates ?? []
        
        GraniteLogger.info("compiling tonal model\nself:String(describing: self)", .expedition, focus: true)
        
        connection.update(\ToneDependency.tone.compile.state, value: .compiling)
        
        if let model = TonalModels.generate(tone: tone, moc: coreDataInstance) {
            connection.update(\ToneDependency.tone.compile.state, value: .compiled)
            connection.update(\ToneDependency.tone.compile.model, value: model)
            
            let tonalModel: TonalModel = .init(model,
                                               daysTrained: daysTrained,
                                               tuners: tuners,
                                               quote: quote,
                                               range: range,
                                               isStrategy: false)
            
            tonalModel.precompute()
            connection.update(\ToneDependency.tone.compile.tonalModel, value: tonalModel)
        }
        
    }
}
