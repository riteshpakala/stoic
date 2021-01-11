//
//  TonalFindComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalFindComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalFindCenter, TonalFindState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            GraniteText("set the tone",
                        .title2,
                        .bold)
                .padding(.top, Brand.Padding.large)
            
            VStack {
                AssetSearchComponent(
                    state: inject(\.envDependency,
                                     target: \.searchTone.state))
                    .share(.init(dep(\.hosted,
                                     TonalFindCenter.route),
                                 relays(
                                    [StockRelay.self,
                                     CryptoRelay.self])))
            }
            
            if command.center.findState == .parsed {
                PaddingVertical()
                
                VStack {
                    GraniteText("days to train",
                                .subheadline,
                                .regular,
                                .leading)
                    
                    BasicSliderComponent(
                        state: inject(\.envDependency,
                                         target: \.tone.find.sliderDays))
                        .listen(to: command)
                        .padding(.top, Brand.Padding.medium)
                    
                    GraniteText("\(command.center.daysSelected) days", .subheadline, .regular)
                }
                .padding(.top, Brand.Padding.large)
                .padding(.bottom, Brand.Padding.medium)
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .transition(.move(edge: .bottom))
            }
            
        }/*.onTapGesture {
            sendEvent(TonalFindEvents.Find.init(ticker: "MSFT"))
        }*/
    }
}
