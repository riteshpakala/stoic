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
        let tuners = inject(\.envDependency,
                               target: \.tone.tune.tuners)
        
        return tuners?[date]?.slider ?? .init()
    }
    
    func getTunerSentiment(date: Date) -> SentimentOutput {
        return state.tuners[date]?.slider.sentiment ??
            (command.center.tonalSentiment.sentimentsByDay[date] ?? .zero)
    }
    
    public var body: some View {
        VStack {
            GraniteText("tune the tone",
                        .headline,
                        .bold)
                .padding(.top, Brand.Padding.medium)
            Spacer()
//            SliderBinding(depObject(\.envDependency,
//                                    target: \EnvironmentDependency.$view.scrollOffset)!)
            if command.center.sentimentIsAvailable {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                        ForEach(command.center.tonalSentiment.datesByDay,
                                id: \.self) { sentimentDate in
                            
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
                .padding(.leading, Brand.Padding.large)
                .padding(.trailing, Brand.Padding.large)
                
                GraniteButtonComponent(state: .init("tune")).onTapGesture {
                    sendEvent(TonalTuneEvents.Tune())
                }
            }
        }
    }
}

//MARK: -- Empty State Settings
extension TonalTuneComponent {
    
    public var emptyText: String {
        "select a range of days,\nto set a tonal pattern"
    }
    
    public var isDependancyEmpty: Bool {
//        state.sentimentLoadingProgress == 0.0
        command.center.sentimentIsAvailable == false
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.redBurn, Brand.Colors.yellow])
    }
}
