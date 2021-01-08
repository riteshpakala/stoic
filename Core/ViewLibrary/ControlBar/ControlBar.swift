//
//  ControlBar.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import SwiftUI

public struct ControlBar: View {
    var isIPhone: Bool
    var currentRoute: Route
    var onRoute: ((Route) -> Void)
    
    public var body: some View {
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
                        maxWidth: 175,
                        maxHeight: .infinity,
                        alignment: .center)
                        .padding(.top, Brand.Padding.large*2)
                        .padding(.leading, Brand.Padding.large+Brand.Padding.medium)
            }
        }
    }
    
    var actions: some View {
        Passthrough {
                
            HStack {
                Image("home_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                GraniteText("home",
                            .title3,
                            .regular,
                            .leading,
                            style: .disabled,
                            selected: currentRoute == .home)
               
            }.onTapGesture {
                onRoute(.home)
            }
                
               
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("floor_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                GraniteText("floor",
                            .title3,
                            .regular,
                            .leading,
                            style: .disabled,
                            selected: currentRoute == .floor)
            }.onTapGesture {
                onRoute(.floor)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("model_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                GraniteText("models",
                            .title3,
                            .regular,
                            .leading,
                            style: .disabled,
                            selected: currentRoute == .models)
            }.onTapGesture {
                onRoute(.models)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("settings_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                GraniteText("settings",
                            .title3,
                            .regular,
                            .leading,
                            style: .disabled,
                            selected: currentRoute == .settings)
            }.onTapGesture {
                onRoute(.settings)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                GraniteText("debug",
                            Brand.Colors.red,
                            .title3,
                            .bold,
                            .leading,
                            style: .disabled)
            }.onTapGesture {
                onRoute(.debug(.models))
            }
        }
    }
}
