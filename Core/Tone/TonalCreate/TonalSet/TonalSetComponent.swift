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
    
    func rangeIsSelected(_ index: TonalRange) -> Bool {
        command.center.envDependency.tone.selectedRange == index
    }
    
    func backgroundColorForRange(_ index: TonalRange) -> Color {
        return rangeIsSelected(index) ? Brand.Colors.yellow : Brand.Colors.black
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                GradientView(colors: [Brand.Colors.redBurn,
                                      Brand.Colors.marble],
                             cornerRadius: 0.0,
                             direction: .top)
                            .offset(x: 0,
                                    y: (geometry.size.height*(1.0 - state.sentimentLoadingProgress.asCGFloat)))
                            .animation(.default)
            }
            
            VStack {
                VStack {
                    HStack {
                        GraniteText("select a range",
                                    .subheadline,
                                    .regular,
                                    .leading)
                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                       
                        Spacer()
                        
                        if state.sentimentLoadingProgress > 0.0 {
                            GraniteText("\(state.sentimentLoadingProgress.percentRounded)%",
                                        .subheadline,
                                        .bold,
                                        .trailing)
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                        }
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                        ForEach(command.center.tonalRangeData, id: \.self) { tonalRangeIndex in
                            
                            VStack {
                                backgroundColorForRange(tonalRangeIndex).overlay(
                                    GraniteText(tonalRangeIndex.dateInfoShortDisplay,
                                                rangeIsSelected(tonalRangeIndex) ? Brand.Colors.black : Brand.Colors.white,
                                                .subheadline,
                                                .regular)
                                )
                                .frame(maxWidth: .infinity,
                                       minHeight: 75,
                                       maxHeight: 120,
                                       alignment: .center)
                                .cornerRadius(8)
                                .shadow(color: .black, radius: 4, x: 2, y: 2)
                                .onTapGesture(perform:
                                                sendEvent(TonalSetEvents.Set(
                                                            tonalRangeIndex), haptic: .light))
                                
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
            
            if command.center.stage == .fetching {
                GraniteDisclaimerComponent(state:
                                            .init("please wait, * stoic is\nfetching large\namounts of data\nto begin training", opacity: 0.57))
            }
            
        }.clipped()
    }
}

//MARK: -- Empty State Settings
extension TonalSetComponent {
    
    public var emptyText: String {
        "search for a market\nto generate tonal similarities\nfound in the past"
    }
    
    public var isDependancyEmpty: Bool {
        command.center.tonalRangeData.isEmpty
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.marble, Brand.Colors.redBurn])
    }
}
