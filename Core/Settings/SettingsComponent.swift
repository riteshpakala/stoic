//
//  SettingsComponent.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SettingsComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SettingsCenter, SettingsState> = .init()
    
    public init() {}
    
    var version: String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return "unknown"
        }
        let version = (dictionary["CFBundleShortVersionString"] as? String) ?? "unknown"
//        let build = dictionary["CFBundleVersion"] as! String
        return "\(version)"
    }
    
    public var body: some View {
        VStack {
            Spacer()
            GraniteText("* stoic v\(version)",
                        Brand.Colors.marble,
                        .headline,
                        .bold)
                        .padding(.bottom, Brand.Padding.xSmall)
            GraniteText("engine: \(TonalModels.engine)",
                        Brand.Colors.yellow,
                        .subheadline,
                        .bold)
                        .padding(.bottom, Brand.Padding.xSmall)
            GraniteText("© 2019-\(Date.today.dateComponents().year) Stoic Collective, LLC.\nAll Rights Reserved",
                        .footnote)
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
            Spacer()
        }.frame(maxWidth: .infinity)
    }
}
