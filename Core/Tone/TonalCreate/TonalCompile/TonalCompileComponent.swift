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
        let tuner = inject(\.envDependency,
                               target: \.tone.compile.slider)
        return tuner ?? .init()
    }
    
    public var body: some View {
        VStack {
            if command.center.compileState == .compiled,
               let security = command.center.latestSecurity {
                
                SecurityDetailComponent(state: .init(.expanded(.init(object: security)),
                                                     quote: command.center.quote,
                                                     model: command.center.model))
                    .share(.init(dep(\.hosted,
                                     TonalCompileCenter.route)))
            }
            
            Spacer()
            
            VStack {
                if command.center.compileState == .readyToCompile {
                    GraniteButtonComponent(state: .init("compile",
                                                        action: {
                                                            sendEvent(TonalCompileEvents.Compile(), haptic: .light)
                                                        }))
                } else if command.center.compileState == .compiled {
                    GraniteButtonComponent(state: .init("save",
                                                        action: {
                                                            sendEvent(TonalCompileEvents.Save(), haptic: .light)
                                                        }))
                }
            }
            .padding(.top, Brand.Padding.large)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

//MARK: -- Empty State Settings
extension TonalCompileComponent {
    
    public var emptyText: String {
        "compile & save\nas you tune to your liking.\nthen use your model\nat any time inside\n* stoic"
    }
    
    public var isDependancyEmpty: Bool {
        command.center.compileState == .none
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.yellow, Brand.Colors.purple])
    }
}
