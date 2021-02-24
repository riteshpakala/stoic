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
                GradientView(colors: [Brand.Colors.greyV2.opacity(0.66),
                                      Brand.Colors.grey.opacity(0.24)],
                             cornerRadius: 6.0,
                             direction: .topLeading)
                    .frame(
                        width: 36,
                        height: 36,
                        alignment: .center)
                    .overlay (
                        VStack {
                            if let image = state.asset.symbolImage {
                                image
                                .frame(width: 20,
                                       height: 20,
                                       alignment: .center)
                                .foregroundColor(Brand.Colors.black)
                            } else {
                                GraniteText(state.asset.symbol,
                                            Brand.Colors.black,
                                            .title3, .bold)
                            }
                        }
                    
                    )
                    .background(state.asset.symbolColor.cornerRadius(6.0)
                                    .shadow(color: Color.black, radius: 6.0, x: 3.0, y: 2.0))
                
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
                }
                
                if state.asset.showDescription1 {
                    VStack(alignment: .trailing) {
                        
                        switch state.asset.assetType {
                        case .model:
                            GraniteText(state.asset.description1,
                                        state.asset.symbolColor,
                                        .subheadline,
                                        .regular,
                                        .trailing,
                                        addSpacers: false)
                        default:
                            GraniteText(state.asset.description1,
                                        state.asset.symbolColor,
                                        .headline,
                                        .regular)
                            
                            GraniteText(state.asset.description1_sub,
                                        state.security.statusColor,
                                        .subheadline,
                                        .regular)
                        }
                    }.padding(.trailing, Brand.Padding.medium)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Spacer()
                    
                    switch state.assetGridType {
                    case .standard:
                        VStack(alignment: .center, spacing: 4) {
                            if state.asset.showDescription2 {
                                GraniteText(state.asset.description2,
                                            state.asset.symbolColor,
                                            .subheadline,
                                            .regular)
                                    .frame(width: 60, height: 12, alignment: .bottom)
                            }
                            
                            (state.security.statusColor)
                                .clipShape(Circle())
                                .frame(width: 6, height: 6, alignment: .top)
                        }
                    case .add:
                        Circle()
                            .foregroundColor(state.asset.symbolColor).overlay(
                            
                                GraniteText("+",
                                            Brand.Colors.black,
                                            .headline,
                                            .bold)
                                            .shadow(color: .black, radius: 6, x: 1, y: 1)
                            
                            
                            )
                            .frame(width: 24, height: 24)
                            .padding(.leading, Brand.Padding.small)
                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                    case .radio:
                        Circle()
                            .foregroundColor(state.asset.symbolColor).overlay(
                            
                                Circle()
                                    .foregroundColor(Brand.Colors.black)
                                    .padding(.top, Brand.Padding.xSmall)
                                    .padding(.leading, Brand.Padding.xSmall)
                                    .padding(.trailing, Brand.Padding.xSmall)
                                    .padding(.bottom, Brand.Padding.xSmall)
                                    .shadow(color: .black, radius: 2, x: 1, y: 1).overlay(
                                    
                                    
                                        Circle()
                                            .foregroundColor(state.radioSelections.contains(state.asset.assetID) ? state.asset.symbolColor : Brand.Colors.black)
                                            .padding(.top, Brand.Padding.xSmall)
                                            .padding(.leading, Brand.Padding.xSmall)
                                            .padding(.trailing, Brand.Padding.xSmall)
                                            .padding(.bottom, Brand.Padding.xSmall)
                                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                                    )
                            )
                            .frame(width: 24, height: 24)
                            .padding(.leading, Brand.Padding.small)
                        
                    default:
                        EmptyView.init()
                    }
                    
                    Spacer()
                }
                .padding(.trailing, Brand.Padding.medium)
                
            }.opacity(state.asset.inValid ? 0.75 : 1.0)
            
            Rectangle().frame(height: 2.0,
                              alignment: .leading)
                .foregroundColor(.black)
                .padding(.top, Brand.Padding.small)
        }
    }
}
