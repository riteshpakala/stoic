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
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Brand.Padding.medium) {
                ForEach(0..<state.chunkedRangeDate.count, id: \.self) { tonalChunkIndex in
                    
                    HStack(spacing: Brand.Padding.medium) {
                        ForEach(0..<state.chunkedRangeDate[tonalChunkIndex].count, id: \.self) { tonalRangeIndex in
                            
                            Brand.Colors.black.overlay(
                            
                                Text(state.chunkedRangeDate[tonalChunkIndex][tonalRangeIndex].dateInfoShortDisplay)
                                    .granite_innerShadow(
                                    Brand.Colors.white,
                                    radius: 3,
                                    offset: .init(x: 2, y: 2))
                                    .multilineTextAlignment(.center)
                                    .font(Fonts.live(.subheadline, .regular))
                            )
                            .frame(width: 120, height: 75, alignment: .center)
                            .cornerRadius(8)
                            .onTapGesture(perform:
                                            sendEvent(TonalCreateEvents.Tune(
                                                        state.chunkedRangeDate[tonalChunkIndex][tonalRangeIndex]),
                                                      contact: true))
                           
                            
                        }
                    }
                    
                }
            }
        }
    }
}
