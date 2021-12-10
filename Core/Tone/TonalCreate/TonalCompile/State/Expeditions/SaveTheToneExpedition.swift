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
        
        guard let tone = connection.retrieve(\ToneDependency.tone) else {
            GraniteLogger.error("saving tonal model failed - no tone\nself:String(describing: self)",
                                .expedition)
            return
        }
        
        guard let quote = tone.find.quote else {
            GraniteLogger.error("saving tonal model failed - no quote\nself:String(describing: self)",
                                .expedition)
            return
        }
        
        //let daysTrained = tone.find.daysSelected
        let tuners = Array(tone.tune.tuners.map { $0.value.slider.sentiment })
        let range = tone.selectedRange?.dates ?? []
        guard let model = tone.compile.model else {
            GraniteLogger.error("saving tonal model failed - no model\nself:String(describing: self)",
                                .expedition)
            return
        }
        
        //guard let security = tone.find.security else { return }
        
        //TODO: Maybe a user error message is necessary here.
        //its supposed blocks the same model saved multiple times.
        //so hopefully it works.
        //guard !modelExists else { return }
        if let tonalModel = model.save(forQuote: quote,
                                       range: range,
                                       tuners: tuners,
                                       moc: coreDataInstance) {
            connection.update(\ToneDependency.tone.compile.tonalModel, value: tonalModel)
            
            GraniteLogger.info("saved tonal model", .expedition, focus: true)
        }
    }
}
