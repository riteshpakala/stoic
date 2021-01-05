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
        let tuner = depObject(\.tonalCreateDependency,
                               target: \.tone.compile.slider)
        return tuner ?? .init()
    }
    
    public var body: some View {
        VStack {
            
            if command.center.compileState == .compiled {
                Text("Prediction: \(state.currentPrediction)")
                    .granite_innerShadow(
                        Brand.Colors.purple,
                        radius: 3,
                        offset: .init(x: 2, y: 2))
                    .multilineTextAlignment(.center)
                    .font(Fonts.live(.title, .bold))
                
                SentimentSliderComponent(state: tunerState).listen(to: command)
               
                Text(tunerState.sentiment.asString)
                    .granite_innerShadow(
                        Brand.Colors.yellow,
                        radius: 3,
                        offset: .init(x: 2, y: 2))
                    .multilineTextAlignment(.center)
                    .font(Fonts.live(.subheadline, .regular))
            }
            
        }.onAppear(perform: {
            if command.center.compileState == .readyToCompile {
                sendEvent(TonalCompileEvents.Compile())
            }
        })
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
