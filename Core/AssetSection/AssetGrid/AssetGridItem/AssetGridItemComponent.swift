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
                Spacer().frame(width: 12)
                
                Text(state.security.indicator)
                    .frame(
                        width: 28,
                        height: 28,
                        alignment: .center)
                    .font(Fonts.live(.title3, .bold))
                    .foregroundColor(Brand.Colors.black)
                    .background(Brand.Colors
                                    .marble
                                    .granite_innerShadow(radius: 3)
                                    .cornerRadius(6.0))
                    .shadow(radius: 3, x: 2, y: 2)
                
                Spacer().frame(width: 12)
                
                VStack(alignment: .leading) {
                    Text(state.security.ticker)
                        .granite_innerShadow(
                            Brand.Colors.white,
                            radius: 4,
                            offset: .init(x: 1, y: 2))
                        .multilineTextAlignment(.leading)
                        .font(Fonts.live(.subheadline, .regular))
                    
                    GraniteText("volume: \(state.security.volumeValue.asInt)",
                                Brand.Colors.marble,
                                .footnote,
                                .regular).multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack {
                    GraniteText("$\(state.security.lastValue.display)",
                                Brand.Colors.marble,
                                .subheadline,
                                .regular).multilineTextAlignment(.trailing)
                    
                    GraniteText("\(state.security.isGainer ? "+" : "-")$\(state.security.prettyChangePercent)",
                                state.security.isGainer ? Brand.Colors.green : Brand.Colors.red,
                                .footnote,
                                .regular).multilineTextAlignment(.trailing)
                }
                
                Spacer().frame(width: 12)
                
                VStack(alignment: .center, spacing: 2) {
                    Spacer()
                    GraniteText("\(state.security.changePercentValue.display)%",
                                Brand.Colors.marble,
                                .footnote,
                                .regular)
                        .frame(height: 12, alignment: .bottom)
                    
                    Color.green.clipShape(Circle())
                        .frame(width: 6, height: 6, alignment: .top)
                    Spacer()
                }
                .padding(.trailing, 12)
                .foregroundColor(Brand.Colors.marble)
                .fixedSize()
                
            }
            
            Rectangle().frame(height: 1.0, alignment: .leading).foregroundColor(.black)
        }
        
    }
}
