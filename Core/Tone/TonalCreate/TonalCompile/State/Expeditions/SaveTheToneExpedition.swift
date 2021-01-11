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
        
        print("{TEST} save 1")
        guard let tone = connection.retrieve(\EnvironmentDependency.tone) else {
            return
        }
        print("{TEST} save 2")
        guard let quote = tone.find.quote else { return }
        print("{TEST} save 3")
        let daysTrained = tone.find.daysSelected
        let tuners = Array(tone.tune.tuners.map { $0.value.slider.sentiment })
        let range = tone.selectedRange?.dates ?? []
        guard let model = tone.compile.model else { return }
        
            print("{TEST} save 4")
        let tonalModel: TonalModel = .init(model,
                                           daysTrained: daysTrained,
                                           tuners: tuners,
                                           quote: quote,
                                           range: range)
        
        tonalModel.save(moc: coreDataInstance) { success in
            if success {
                print("{TEST} save 5")
                connection.update(\EnvironmentDependency.tone.compile.tonalModel, value: tonalModel)
            }
        }
    }
}
