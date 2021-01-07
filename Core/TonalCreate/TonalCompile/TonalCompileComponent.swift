//
//  TonalCompileComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalCompileComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalCompileCenter, TonalCompileState> = .init()
    
    public init() {}
    
    var tunerState: SentimentSliderState {
        let tuner = depObject(\.envDependency,
                               target: \.tone.compile.slider)
        return tuner ?? .init()
    }
    
    public var body: some View {
        VStack {
            if command.center.compileState == .compiled {
                GraniteText("\(state.currentPrediction)",
                            Brand.Colors.purple,
                            .title,
                            .bold)
                
                SentimentSliderComponent(state: tunerState).listen(to: command)
               
                GraniteText(tunerState.sentiment.asString,
                            Brand.Colors.yellow,
                            .subheadline,
                            .regular)
            }
            
            SecurityDetailComponent()
        }.onAppear(perform: {
            if command.center.compileState == .readyToCompile {
                sendEvent(TonalCompileEvents.Compile())
            }
        })
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
