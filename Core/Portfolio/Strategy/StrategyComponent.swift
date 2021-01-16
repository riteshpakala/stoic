//
//  StrategyComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StrategyComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<StrategyCenter, StrategyState> = .init()
    
    public init() {}
    
    let columns = [
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
    ]
    
    public var body: some View {
        VStack {
            VStack {
                GraniteText("strategy",
                            .headline,
                            .bold,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2,
                                    x: 1,
                                    y: 1)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
//                    ForEach(command.center.tonalRangeData, id: \.self) { tonalRangeIndex in
//
//                        VStack {
//                            backgroundColorForRange(tonalRangeIndex).overlay(
//                                GraniteText(tonalRangeIndex.dateInfoShortDisplay,
//                                            rangeIsSelected(tonalRangeIndex) ? Brand.Colors.black : Brand.Colors.white,
//                                            .subheadline,
//                                            .regular)
//                            )
//                            .frame(maxWidth: .infinity,
//                                   minHeight: 75,
//                                   maxHeight: 120,
//                                   alignment: .center)
//                            .cornerRadius(8)
//                            .shadow(color: .black, radius: 4, x: 2, y: 2)
//                            .onTapGesture(perform:
//                                            sendEvent(TonalSetEvents.Set(
//                                                        tonalRangeIndex), haptic: .light))
//
//                            GraniteText(tonalRangeIndex.avgSimilarityDisplay,
//                                        tonalRangeIndex.avgSimilarityColor,
//                                        .subheadline,
//                                        .regular)
//                        }
//                    }
                }
            }
        }
    }
}
