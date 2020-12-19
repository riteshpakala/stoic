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
        HStack {
//            Image("").frame(
//                width: 50,
//                height: 50,
//                alignment: .leading)
//                .background(Color.black)
//                .padding(.leading, 12)
            
            Spacer().frame(width: 12)
            
            VStack(alignment: .leading) {
                Text("$MSFT").multilineTextAlignment(.leading)
                Text("volume: 35m").multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            VStack {
                Text("+4.5%")
                Text("$\(state.price)")
            }
            
            Spacer().frame(width: 12)
            
            VStack(spacing: 2) {
                Spacer()
                Text("+4.5%").frame(height: 12, alignment: .bottom)
                Color.green.clipShape(Circle()).frame(width: 6, height: 6, alignment: .top)
                Spacer()
            }.padding(.trailing, 12)
            
        }.foregroundColor(.blue)
    }
}
