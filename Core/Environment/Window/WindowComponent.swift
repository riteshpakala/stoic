//
//  WindowComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct WindowComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<WindowCenter, WindowState> = .init()
    
    public init() {}
    
    public var body: some View {
        switch state.config.kind {
        case .topVolume(let securityType),
             .winners(let securityType),
             .losers(let securityType):
            AssetSectionComponent(
                state: .init(windowType: state.config.kind,
                             securityType))
                .share(.init(dep(\.hosted)))
        case .portfolio(let type):
            PortfolioComponent(state: .init(type))
                .share(.init(dep(\.hosted)))
                .listen(to: command)
        case .floor:
            FloorComponent()
                .share(.init(dep(\.hosted,
                                 WindowCenter.route)))
        case .search:
            AssetSearchComponent(state: inject(\.envDependency,
                                                  target: \.search.state))
                .share(.init(dep(\.hosted,
                                 WindowCenter.route)))
        case .securityDetail(let kind):
            SecurityDetailComponent(state: .init(kind,
                                                 quote: command.center.envDependency.detail.quote,
                                                 model: command.center.envDependency.detail.model))
                .share(.init(dep(\.hosted,
                                 WindowCenter.route)))
        case .tonalCreate(let stage):
            TonalCreateComponent(state: .init(stage))
                .share(.init(dep(\.hosted)))
        case .tonalBrowser(let payload):
            TonalModelsComponent(state: inject(\.envDependency,
                                               target: \.tonalModels))
                .payload(payload)
                .share(.init(dep(\.hosted)))
        case .special:
            SpecialComponent()
        case .discuss:
            DiscussComponent()
                .share(.init(dep(\.hosted)))
                .listen(to: command)
        case .settings:
            SettingsComponent()
        default:
            EmptyView.init().hidden()
        }
    }
}

extension GraniteComponent {
    public var showEmptyState: some View {
        Passthrough {
            if self.isDependancyEmpty {
                GraniteEmptyComponent(state: .init(self.emptyText))
                    .payload(self.emptyPayload)
            } else {
                self
            }
        }
    }
}
