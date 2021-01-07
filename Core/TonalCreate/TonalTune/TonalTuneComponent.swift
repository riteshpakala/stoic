//
//  TonalTuneComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalTuneComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalTuneCenter, TonalTuneState> = .init()
    
    public init() {
        
    }
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    func getSentiment(date: Date) -> SentimentSliderState {
        let tuners = depObject(\.envDependency,
                               target: \.tone.tune.tuners)
        
        return tuners?[date]?.slider ?? .init()
    }
    
    func getTunerSentiment(date: Date) -> SentimentOutput {
        return state.tuners[date]?.slider.sentiment ??
            (command.center.tonalSentiment.sentimentsByDay[date] ?? .zero)
    }
    
    public var body: some View {
        VStack {
            HeaderComponent(state: .init("tune the tone"))
            Spacer()
            if command.center.sentimentIsAvailable {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                        ForEach(command.center.tonalSentiment.datesByDay, id: \.self) { sentimentDate in
                            
                            VStack {
                                GraniteText(sentimentDate.asString,
                                            .subheadline,
                                            .regular)
                                
                                SentimentSliderComponent(state: getSentiment(date: sentimentDate)).listen(to: command)
                                
                                GraniteText(getTunerSentiment(date: sentimentDate).asString,
                                            Brand.Colors.yellow,
                                            .subheadline,
                                            .regular)
                            }
                        }
                    }
                }
                .padding(.top, Brand.Padding.large)
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                
                BasicButton(text: "Generate").onTapGesture {
                    sendEvent(TonalTuneEvents.Tune())
                }
                .padding(.bottom, Brand.Padding.medium)
                
            } else {
                
                Brand.Colors.black.overlay(
                    VStack {
                        if command.center.tone.tune.sentiment == nil {
                            GraniteText("loading... \(state.sentimentLoadingProgress)")
                        }
                    }
                )
                .frame(width: 120, height: 75, alignment: .center)
                .cornerRadius(8)
            }
        }
    }
}
