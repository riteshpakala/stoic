//
//  ControlBar.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import SwiftUI
import GraniteUI

public struct ControlBar: View {
    var isIPhone: Bool
    var iconSize: CGFloat {
        if isIPhone {
            return 20
        } else {
            return 18
        }
    }
    var fontSize: Fonts.FontSize = .headline
    var currentRoute: Route
    var onRoute: ((Route) -> Void)
    
    public var body: some View {
        if isIPhone {
            HStack(alignment: .center) {
                actions
            }.frame(maxWidth: .infinity,
                    minHeight: EnvironmentStyle.ControlBar.iPhone.minHeight,
                    maxHeight: EnvironmentStyle.ControlBar.iPhone.maxHeight,
                    alignment: .center)
            .padding(.top, Brand.Padding.small)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
        } else {
            VStack(alignment: .leading) {
                
                actions
                
                Spacer()
                
            }.frame(minWidth: EnvironmentStyle.ControlBar.Default.minWidth,
                    maxWidth: EnvironmentStyle.ControlBar.Default.maxWidth,
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
                
                GraniteButtonComponent(state: .init(.image("home_icon"),
                                                    selected: currentRoute == .home && isIPhone,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.home)
                                                    }))
                                        .padding(.trailing,
                                                 isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("home",
                                fontSize,
                                .regular,
                                .leading,
                                style: .v2Selection,
                                selected: currentRoute == .home)
                } else {
                    Spacer()
                }
            }
                
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large, Brand.Colors.black)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                
                GraniteButtonComponent(state: .init(.image("floor_icon"),
                                                    selected: currentRoute == .floor && isIPhone,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.floor)
                                                    }))
                                        .padding(.trailing,
                                                 isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("floor",
                                fontSize,
                                .regular,
                                .leading,
                                style: .v2Selection,
                                selected: currentRoute == .floor)
                } else {
                    Spacer()
                }
            }
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large, Brand.Colors.black)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                
                GraniteButtonComponent(state: .init(.image("community_icon"),
                                                    selected: currentRoute == .discuss && isIPhone,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.discuss)
                                                    }))
                                        .padding(.trailing,
                                                 isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("discuss",
                                fontSize,
                                .regular,
                                .leading,
                                style: .v2Selection,
                                selected: currentRoute == .discuss)
                } else {
                    Spacer()
                }
            }
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large, Brand.Colors.black)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                
                GraniteButtonComponent(state: .init(.image("model_icon"),
                                                    selected: currentRoute.isModels && isIPhone,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.models(.init(object: nil)))
                                                    }))
                                        .padding(.trailing,
                                                 isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("models",
                                fontSize,
                                .regular,
                                .leading,
                                style: .v2Selection,
                                selected: currentRoute.isModels)
                } else {
                    Spacer()
                }
            }
            
            if isIPhone {
                PaddingHorizontal(Brand.Padding.large, Brand.Colors.black)
            } else {
                PaddingVertical(Brand.Padding.medium9)
            }
            
            HStack(alignment: .center) {
                if isIPhone {
                    Spacer()
                }
                
                GraniteButtonComponent(state: .init(.image("settings_icon"),
                                                    selected: currentRoute == .settings && isIPhone,
                                                    size: .init(iconSize),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        onRoute(.settings)
                                                    }))
                                        .padding(.trailing,
                                                 isIPhone ? 0.0 : Brand.Padding.medium)
                
                if !isIPhone {
                    GraniteText("settings",
                                fontSize,
                                .regular,
                                .leading,
                                style: .v2Selection,
                                selected: currentRoute == .settings)
                } else {
                    Spacer()
                }
            }
            
//            #if DEBUG
//
//            if isIPhone {
//                PaddingHorizontal(Brand.Padding.large)
//            } else {
//                PaddingVertical(Brand.Padding.medium9)
//            }
//            HStack(alignment: .center) {
//                if isIPhone {
//                    Spacer()
//                }
//                if !isIPhone {
//                    GraniteText("debug",
//                                Brand.Colors.red,
//                                fontSize,
//                                .bold,
//                                .leading,
//                                style: .basic)
//                } else {
//                    GraniteText("d",
//                                Brand.Colors.red,
//                                fontSize,
//                                .bold,
//                                .leading,
//                                style: .basic)
//                }
//
//                if isIPhone {
//                    Spacer()
//                }
//            }.onTapGesture {
//                onRoute(.debug(.models))
//            }
//
//            #endif
        }
    }
}
