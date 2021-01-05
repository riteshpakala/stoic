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
    
    public func link() {
        command.link(\TonalState.sentimentProgress,
                     target:\.sentimentLoadingProgress)
    }
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    func getSentiment(date: Date) -> SentimentSliderState {
        let tuners = depObject(\.tonalCreateDependency,
                                     target: \.tone.tuners)
        
        return tuners?[date]?.slider ?? .init()
    }
    
    func getTunerSentiment(date: Date) -> SentimentOutput {
        return state.tuners[date]?.slider.sentiment ??
            (command.center.tonalSentiment.sentimentsByDay[date] ?? .zero)
    }
    
    public var body: some View {
        VStack {
            
            if command.center.sentimentIsAvailable {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                        ForEach(command.center.tonalSentiment.datesByDay, id: \.self) { sentimentDate in
                            
                            VStack {
                                Text(sentimentDate.asString)
                                    .granite_innerShadow(
                                        Brand.Colors.white,
                                        radius: 3,
                                        offset: .init(x: 2, y: 2))
                                    .multilineTextAlignment(.center)
                                    .font(Fonts.live(.subheadline, .regular))
                                
                                SentimentSliderComponent(state: getSentiment(date: sentimentDate)).listen(to: command)
                                
                                Text(getTunerSentiment(date: sentimentDate).asString)
                                    .granite_innerShadow(
                                        Brand.Colors.yellow,
                                        radius: 3,
                                        offset: .init(x: 2, y: 2))
                                    .multilineTextAlignment(.center)
                                    .font(Fonts.live(.subheadline, .regular))
                            }
                        }
                    }
                }
                
            } else {
                
                Brand.Colors.black.overlay(
                    VStack {
                        if command.center.tone.sentiment == nil {
                            Text("loading... \(state.sentimentLoadingProgress)")
                                .granite_innerShadow(
                                    Brand.Colors.white,
                                    radius: 3,
                                    offset: .init(x: 2, y: 2))
                                .multilineTextAlignment(.center)
                                .font(Fonts.live(.subheadline, .regular))
                        }
                    }
                )
                .frame(width: 120, height: 75, alignment: .center)
                .cornerRadius(8)
            }
            
        }.padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
        .background(Brand.Colors.black)
    }
}
