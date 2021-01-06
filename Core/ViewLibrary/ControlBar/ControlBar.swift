//
//  ControlBar.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import SwiftUI

struct ControlBar: View {
    var isIPhone: Bool
    @Binding var selectedFolder: String?

    var body: some View {
        VStack {
            if isIPhone {
                HStack(alignment: .center) {
                    
                    actions
                    
                }.frame(minWidth: 100,
                        maxWidth: 120,
                        maxHeight: .infinity,
                        alignment: .center)
            } else {
                VStack(alignment: .leading) {
                    
                    actions
                    
                    Spacer()
                    
                }.frame(minWidth: 100,
                        maxWidth: 200,
                        maxHeight: .infinity,
                        alignment: .center).padding(.top, Brand.Padding.large)
            }
        }.background(Brand.Colors.black)
    }
    
    var actions: some View {
        Passthrough {
            HStack {
                Image("home_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.small)
                
                GraniteText("home", .title3, .bold)
            }
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("floor_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.small)
                
                GraniteText("floor", .title3, .bold)
            }
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("model_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.small)
                
                GraniteText("models", .title3, .bold)
            }
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("settings_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.small)
                
                GraniteText("settings", .title3, .bold)
            }
        }
    }
}
