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
    var iconSize: CGFloat = 18
    var fontSize: Fonts.FontSize = .headline
    var currentRoute: Route
    var onRoute: ((Route) -> Void)
    
    public var body: some View {
        if isIPhone {
            HStack(alignment: .center) {
                Spacer()
                actions
                Spacer()
            }.frame(maxWidth: .infinity,
                    minHeight: 36,
                    maxHeight: 42,
                    alignment: .center)
        } else {
            VStack(alignment: .leading) {
                
                actions
                
                Spacer()
                
            }.frame(minWidth: 100,
                    maxWidth: 150,
                    maxHeight: .infinity,
                    alignment: .center)
                    .padding(.top, Brand.Padding.large+Brand.Padding.medium)
                    .padding(.leading, Brand.Padding.large+Brand.Padding.medium)
        }
    }
    
    var actions: some View {
        Passthrough {
                
            HStack {
                Image("home_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("home",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .home)
                }
               
            }.onTapGesture {
                onRoute(.home)
            }
                
               
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("floor_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("floor",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .floor)
                }
            }.onTapGesture {
                onRoute(.floor)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("model_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("models",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .models)
                }
            }.onTapGesture {
                onRoute(.models)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                Image("settings_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("settings",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .settings)
                }
            }.onTapGesture {
                onRoute(.settings)
            }
            
            Spacer().frame(width: Brand.Padding.large, height: Brand.Padding.large)
            HStack {
                if !isIPhone {
                    GraniteText("debug",
                                Brand.Colors.red,
                                fontSize,
                                .bold,
                                .leading,
                                style: .disabled)
                } else {
                    GraniteText("d",
                                Brand.Colors.red,
                                fontSize,
                                .bold,
                                .leading,
                                style: .disabled)
                }
            }.onTapGesture {
                onRoute(.debug(.models))
            }
        }
    }
}
