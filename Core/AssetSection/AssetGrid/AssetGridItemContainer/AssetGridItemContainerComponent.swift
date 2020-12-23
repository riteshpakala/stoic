//
//  AssetGridItemContainerComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridItemContainerComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridItemContainerCenter, AssetGridItemContainerState> = .init()
    
    public init() {}
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                VStack(alignment: .leading, spacing: 0.0) {
                    Spacer()
                    
                    HStack {
                        Spacer().frame(width: 12)
                        
                        Text("crypto")
                            .granite_innerShadow(
                            Brand.Colors.marble,
                            radius: 3,
                            offset: .init(x: 2, y: 2))
                        .multilineTextAlignment(.leading)
                        .font(Fonts.live(.subheadline, .regular))
                        
                        Spacer()
                        
                        Text("price")
                            .granite_innerShadow(
                            Brand.Colors.marble,
                            radius: 3,
                            offset: .init(x: 2, y: 2))
                        .multilineTextAlignment(.trailing)
                        .font(Fonts.live(.subheadline, .regular))
                        
                        Spacer().frame(width: 12)
                        
                        Text("change")
                            .granite_innerShadow(
                            Brand.Colors.marble,
                            radius: 3,
                            offset: .init(x: 2, y: 2))
                        .multilineTextAlignment(.trailing)
                        .font(Fonts.live(.subheadline, .regular))
                            .padding(.trailing, 12)
                        
                    }
                    .padding(.leading, Brand.Padding.large)
                    .padding(.bottom, Brand.Padding.xSmall)
                    
                    Rectangle().frame(height: 1.0, alignment: .leading).foregroundColor(.black)
                }.frame(minHeight: 48, idealHeight: 50, maxHeight: 75)
                
                VStack(alignment: .leading, spacing: 0.0) {
                    ForEach(0..<state.securityData.count, id: \.self) { index in
                        AssetGridItemComponent().payload(.init(object: state.securityData[index]))
                    }
                }.padding(.leading, Brand.Padding.large)
            }
        }
        .background(Brand.Colors.black)
    }
}
