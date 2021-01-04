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
            Spacer().frame(height: Brand.Padding.large)
            SearchComponent(
                state: depObject(\.tonalCreateDependency,
                                 target: \.search.state))
                .shareRelays(relays(
                                [StockRelay.self,
                                 CryptoRelay.self]))
            
            Text("\(command.center.dependency.hosted.identifier)")
            AssetGridComponent()
                .listen(to: command)
                .payload(depPayload(\.tonalCreateDependency,
                                    target: \.search.securities))
            
            BasicSliderComponent(
                state: depObject(\.tonalCreateDependency,
                                 target: \.tone.find.sliderDays))
                .listen(to: command)
            
            Text("\(command.center.daysSelected) days")
            Spacer().frame(height: Brand.Padding.large)
        }.background(Brand.Colors.black).onTapGesture {
            sendEvent(TonalFindEvents.Find.init(ticker: "MSFT"))
        }
    }
}
