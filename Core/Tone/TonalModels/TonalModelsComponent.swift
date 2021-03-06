//
//  TonalModelsComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalModelsComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalModelsCenter, TonalModelsState> = .init()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                GradientView(colors: [Brand.Colors.purple,
                                      Brand.Colors.marble],
                             cornerRadius: 0.0,
                             direction: .top)
                            .shadow(color: Color.black,
                                    radius: 8.0,
                                    x: 4.0,
                                    y: 3.0)
                            .offset(x: 0,
                                    y: (geometry.size.height*(1.0 - (state.syncProgress.isNaN ? 0.0 : state.syncProgress.asCGFloat))))
                            .animation(.default)
            }
            
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        GraniteText("your models",
                                    .headline,
                                    .bold)
                        
                        Spacer()
                        
                        GraniteText(state.statusLabel,
                                    Brand.Colors.purple,
                                    .subheadline,
                                    .regular)
                        
                        GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                            colors: [Brand.Colors.purple,
                                                                     Brand.Colors.marble],
                                                            selected: true,
                                                            size: .init(16),
                                                            padding: .init(0,
                                                                           Brand.Padding.medium9,
                                                                           0,
                                                                           Brand.Padding.medium9),
                                                            action: {
                                                                GraniteHaptic.light.invoke()
                                                                sendEvent(TonalModelsEvents.Update())
                                                            }))
                    }
                    .padding(.leading, Brand.Padding.medium)
                    .padding(.trailing, Brand.Padding.medium)
                    
                    
                    AssetGridComponent(state: .init(.standard,
                                                    context: .tonalBrowser(.empty),
                                                    assetData: state.tones ?? []))
                        .listen(to: command, .stop).showEmptyState
                        
                }.padding(.top, Brand.Padding.large)
                
                GraniteButtonComponent(
                    state: .init(.add,
                                 padding: .init(0, 0, Brand.Padding.xSmall, 0),
                                 action: {
                                    sendEvent(TonalModelsEvents.Add(), haptic: .light)
                                 }))
            }
            
            if state.stage == .updating {
                GraniteDisclaimerComponent(state:
                                            .init("please wait, * stoic is\nupdating your models\nwith the latest data. Keeping your trained days within the same constraint values.", opacity: 0.57))
            }
        }
        .clipped()
    }
}
