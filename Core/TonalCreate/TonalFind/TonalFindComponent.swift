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
                AssetSearchComponent(
                    state: depObject(\.envDependency,
                                     target: \.search.state))
                    .shareRelays(relays(
                                    [StockRelay.self,
                                     CryptoRelay.self]))
                    .inject(dep(\.hosted))
            }
            
            PaddingVertical()
            
            VStack {
                GraniteText("days to train",
                            .subheadline,
                            .regular,
                            .leading)
                
                BasicSliderComponent(
                    state: depObject(\.envDependency,
                                     target: \.tone.find.sliderDays))
                    .listen(to: command)
                    .padding(.top, Brand.Padding.medium)
                
                GraniteText("\(command.center.daysSelected) days", .subheadline, .regular)
            }
            .padding(.top, Brand.Padding.large)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
        }.onAppear(perform: {
            if command.center.findState == .found {
                sendEvent(TonalFindEvents.Find(ticker: command.center.ticker))
            }
        })/*.onTapGesture {
            sendEvent(TonalFindEvents.Find.init(ticker: "MSFT"))
        }*/
    }
}
