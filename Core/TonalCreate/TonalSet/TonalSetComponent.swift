//
//  TonalFindComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalSetComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalSetCenter, TonalSetState> = .init()
    
    public init() {}
    
    let columns = [
        GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),
    ]
    
    public var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Select a range")
                        .granite_innerShadow(
                        Brand.Colors.white,
                        radius: 3,
                        offset: .init(x: 2, y: 2))
                        .multilineTextAlignment(.leading)
                        .font(Fonts.live(.subheadline, .regular))
                    
                    Spacer()
                }.padding(.top, Brand.Padding.large).padding(.bottom, Brand.Padding.medium)
            }.padding(.leading, Brand.Padding.large).padding(.trailing, Brand.Padding.large)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                    ForEach(0..<state.tonalRangeData.count, id: \.self) { tonalRangeIndex in
                        
                        VStack {
                            Color.black.overlay(
                            
                                Text(state.tonalRangeData[tonalRangeIndex].dateInfoShortDisplay)
                                    .granite_innerShadow(
                                    Brand.Colors.white,
                                    radius: 3,
                                    offset: .init(x: 2, y: 2))
                                    .multilineTextAlignment(.center)
                                    .font(Fonts.live(.subheadline, .regular))
                            )
                            .frame(maxWidth: .infinity, minHeight: 75, maxHeight: 120, alignment: .center)
                            .cornerRadius(8)
                            .onTapGesture(perform:
                                            sendEvent(TonalCreateEvents.Tune(
                                                        state.tonalRangeData[tonalRangeIndex]),
                                                      contact: true))
                            
                            Text(state.tonalRangeData[tonalRangeIndex].avgSimilarityDisplay)
                                .granite_innerShadow(
                                state.tonalRangeData[tonalRangeIndex].avgSimilarityColor,
                                radius: 3,
                                offset: .init(x: 2, y: 2))
                                .multilineTextAlignment(.center)
                                .font(Fonts.live(.subheadline, .regular))
                        }
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        
                    }
                }
            }.padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
