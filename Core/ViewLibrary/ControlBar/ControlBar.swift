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
                actions
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
                
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                Image("home_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("home",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .home)
                } else {
                    Spacer()
                }
               
            }.onTapGesture {
                onRoute(.home)
            }
                
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                Image("floor_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("floor",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .floor)
                } else {
                    Spacer()
                }
            }.onTapGesture {
                onRoute(.floor)
            }
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                Image("model_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("models",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .models)
                } else {
                    Spacer()
                }
            }.onTapGesture {
                onRoute(.models)
            }
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                Image("settings_icon")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: iconSize, height: iconSize, alignment: .leading)
                    .padding(.trailing, isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("settings",
                                fontSize,
                                .regular,
                                .leading,
                                style: .disabled,
                                selected: currentRoute == .settings)
                } else {
                    Spacer()
                }
            }.onTapGesture {
                onRoute(.settings)
            }
            
            #if DEBUG
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
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
                
                if isIPhone {
                    Spacer()
                }
            }.onTapGesture {
                onRoute(.debug(.models))
            }
            
            #endif
        }
    }
}
