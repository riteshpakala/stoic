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
                if let image = state.asset.symbolImage {
                    state.asset.symbolColor.frame(
                        width: 36,
                        height: 36,
                        alignment: .center).overlay (
                            
                        image
                        .frame(width: 20,
                               height: 20,
                               alignment: .center)
                        .foregroundColor(Brand.Colors.black)
                        
                        
                        )
                        .cornerRadius(6.0)
                } else {
                    Text(state.asset.symbol)
                        .frame(
                            width: 36,
                            height: 36,
                            alignment: .center)
                        .font(Fonts.live(.title3, .bold))
                        .foregroundColor(Brand.Colors.black)
                        .background(state.asset.symbolColor
    //                                    .granite_innerShadow(radius: 2)
                                        .cornerRadius(6.0))
                }
                
                VStack(alignment: .leading) {
                    GraniteText(state.asset.title,
                                .headline,
                                .regular,
                                .leading)
                    
                    GraniteText(state.asset.subtitle,
                                state.asset.symbolColor,
                                .subheadline,
                                .regular,
                                .leading,
                                style: .init(radius: 2, offset: .init(x: 1, y: 1)))
                }.padding(.trailing, 12)
                
                VStack {
                    GraniteText(state.asset.description1,
                                state.asset.symbolColor,
                                .headline,
                                .regular,
                                .trailing)
                    
                    GraniteText(state.asset.description1_sub,
                                state.security.isGainer ? Brand.Colors.green : Brand.Colors.red,
                                .subheadline,
                                .regular,
                                .trailing)
                }.padding(.trailing, 12)
                
                
                
                VStack(alignment: .center, spacing: 2) {
                    Spacer()
                    
                    switch state.assetGridType {
                    case .standard:
                        VStack(alignment: .center, spacing: 2) {
                            GraniteText(state.asset.description2,
                                        state.asset.symbolColor,
                                        .subheadline,
                                        .regular)
                                .frame(height: 12, alignment: .bottom)
                            
                            (state.security.isGainer ? Brand.Colors.green : Brand.Colors.red)
                                .clipShape(Circle())
                                .frame(width: 6, height: 6, alignment: .top)
                        }.padding(.leading, Brand.Padding.small)
                    case .add:
                        Circle()
                            .foregroundColor(state.asset.symbolColor).overlay(
                            
                                GraniteText("+",
                                            Brand.Colors.black,
                                            .headline,
                                            .bold)
                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                            
                            
                            )
                            .frame(width: 24, height: 24)
                            .padding(.leading, Brand.Padding.small)
                    default:
                        EmptyView.init()
                    }
                    
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
