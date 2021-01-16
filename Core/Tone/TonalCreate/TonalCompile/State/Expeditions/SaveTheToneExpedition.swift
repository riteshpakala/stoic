//
//  SaveTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct SaveTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCompileEvents.Save
    typealias ExpeditionState = TonalCompileState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let tone = connection.retrieve(\EnvironmentDependency.tone) else {
            GraniteLogger.error("saving tonal model failed - no tone\nself:\(self)",
                                .expedition)
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
        guard let model = tone.compile.model else {
            GraniteLogger.error("saving tonal model failed - no model\nself:\(self)",
                                .expedition)
            return
        }
        
        
        let tonalModel: TonalModel = .init(model,
                                           daysTrained: daysTrained,
                                           tuners: tuners,
                                           quote: quote,
                                           range: range)
        
        tonalModel.save(moc: coreDataInstance) { success in
            if success {
                connection.update(\EnvironmentDependency.tone.compile.tonalModel, value: tonalModel)
                
                GraniteLogger.info("saved tonal model\nself:\(self)", .expedition)
            }
        }
    }
}
