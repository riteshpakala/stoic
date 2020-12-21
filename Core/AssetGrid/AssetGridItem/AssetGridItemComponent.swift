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
    
    public init() {
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer().frame(width: 12)
                
                Text("$")
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
                    Text(state.stockData.symbolName)
                        .granite_innerShadow(
                            Brand.Colors.white,
                            radius: 4,
                            offset: .init(x: 1, y: 2))
                        .multilineTextAlignment(.leading)
                        .font(Fonts.live(.subheadline, .regular))
                    Text("volume: \(state.stockData.volume.asInt)")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Brand.Colors.marble)
                        .font(Fonts.live(.footnote, .regular))
                }
                
                Spacer()
                
                VStack {
                    Text("$\(state.stockData.close, specifier: "%.2f")")
                        .granite_innerShadow(
                            Brand.Colors.green,
                            radius: 4,
                            offset: .init(x: 1, y: 2))
                        .font(Fonts.live(.subheadline, .regular))
                }
                
                Spacer().frame(width: 12)
                
                VStack(spacing: 2) {
                    Spacer()
                    Text("+4.5%")
                        .granite_innerShadow(
                            Brand.Colors.marble,
                            radius: 4,
                            offset: .init(x: 1, y: 2))
                        .frame(height: 12, alignment: .bottom)
                    Color.green.clipShape(Circle())
                        .frame(width: 6, height: 6, alignment: .top)
                    Spacer()
                }.padding(.trailing, 12).foregroundColor(Brand.Colors.marble)
                
            }.background(Brand.Colors.black)
            
            Rectangle().frame(height: 1.0, alignment: .leading).foregroundColor(.black)
        }
        
    }
}
