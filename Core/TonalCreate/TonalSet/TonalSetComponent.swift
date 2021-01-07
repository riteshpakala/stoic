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
                GraniteText("select a range",
                            .subheadline,
                            .regular,
                            .leading)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                    ForEach(command.center.tonalRangeData, id: \.self) { tonalRangeIndex in
                        
                        VStack {
                            Color.black.overlay(
                                GraniteText(tonalRangeIndex.dateInfoShortDisplay,
                                            .subheadline,
                                            .regular)
                            )
                            .frame(maxWidth: .infinity, minHeight: 75, maxHeight: 120, alignment: .center)
                            .cornerRadius(8)
                            .onTapGesture(perform:
                                            sendEvent(TonalSetEvents.Set(
                                                        tonalRangeIndex)))
                            
                            GraniteText(tonalRangeIndex.avgSimilarityDisplay,
                                        tonalRangeIndex.avgSimilarityColor,
                                        .subheadline,
                                        .regular)
                        }
                    }
                }
            }
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
