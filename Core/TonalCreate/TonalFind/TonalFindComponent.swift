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
            HeaderComponent(state: .init("set the tone"))
            
            VStack {
                SearchComponent(
                    state: depObject(\.tonalCreateDependency,
                                     target: \.search.state))
                    .shareRelays(relays(
                                    [StockRelay.self,
                                     CryptoRelay.self]))
                
                AssetGridComponent()
                    .listen(to: command)
                    .payload(depPayload(\.tonalCreateDependency,
                                        target: \.search.securities))
            }
            .padding(.top, Brand.Padding.large)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
            PaddingVertical()
            
            VStack {
                GraniteText("days to train",
                            .subheadline,
                            .regular,
                            .leading)
                
                BasicSliderComponent(
                    state: depObject(\.tonalCreateDependency,
                                     target: \.tone.find.sliderDays))
                    .listen(to: command)
                    .padding(.top, Brand.Padding.medium)
                
                GraniteText("\(command.center.daysSelected) days", .subheadline, .regular)
            }
            .padding(.top, Brand.Padding.large)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
        }.onTapGesture {
            sendEvent(TonalFindEvents.Find.init(ticker: "MSFT"))
        }
    }
}
