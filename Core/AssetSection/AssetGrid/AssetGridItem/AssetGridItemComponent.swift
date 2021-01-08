//
//  AssetGridItemComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridItemComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridItemCenter, AssetGridItemState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(state.security.indicator)
                    .frame(
                        width: 36,
                        height: 36,
                        alignment: .center)
                    .font(Fonts.live(.title3, .bold))
                    .foregroundColor(Brand.Colors.black)
                    .background(Brand.Colors
                                    .marble
                                    .granite_innerShadow(radius: 2)
                                    .cornerRadius(6.0))
                
                VStack(alignment: .leading) {
                    GraniteText(state.security.ticker,
                                .headline,
                                .regular,
                                .leading)
                    
                    GraniteText("volume: \(state.security.volumeValue.abbreviate)",
                                Brand.Colors.marble,
                                .subheadline,
                                .regular,
                                .leading,
                                style: .init(radius: 2, offset: .init(x: 1, y: 1)))
                }.padding(.trailing, 12)
                
                VStack {
                    GraniteText("$\(state.security.lastValue.display)",
                                Brand.Colors.marble,
                                .headline,
                                .regular,
                                .trailing)
                    
                    GraniteText("\(state.security.isGainer ? "+" : "-")$\(state.security.prettyChangePercent.percent)",
                                state.security.isGainer ? Brand.Colors.green : Brand.Colors.red,
                                .subheadline,
                                .regular,
                                .trailing)
                }.padding(.trailing, 12)
                
                VStack(alignment: .center, spacing: 2) {
                    Spacer()
                    GraniteText("\(state.security.changePercentValue.display)%",
                                Brand.Colors.marble,
                                .subheadline,
                                .regular)
                        .frame(height: 12, alignment: .bottom)
                    
                    Color.green.clipShape(Circle())
                        .frame(width: 6, height: 6, alignment: .top)
                    Spacer()
                }
                .foregroundColor(Brand.Colors.marble)
                .fixedSize()
                
            }
            
            Rectangle().frame(height: 2.0,
                              alignment: .leading)
                .foregroundColor(.black)
                .padding(.top, Brand.Padding.small)
        }
    }
}
