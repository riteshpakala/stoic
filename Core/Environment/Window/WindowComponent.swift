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
             .losers(let securityType),
             .winnersAndLosers(let securityType):
            AssetSectionComponent(
                state: .init(context: state.config.kind,
                             securityType))
                .attach(to: command)
        case .portfolio(let type):
            PortfolioComponent(state: .init(type))
                .listen(to: command)
        case .floor:
            FloorComponent()
        case .search:
            AssetSearchComponent()
        case .securityDetail(let kind):
            SecurityDetailComponent(state: .init(kind))//,
//                                                 modelID: command.center.detailDependency.detail.modelID))
        case .tonalCreate(let stage):
            TonalCreateComponent(state: .init(stage))
                
        case .tonalBrowser(let payload):
            TonalModelsComponent(state: .init(inject(\.envDependency,
                                                     target: \.tonalModels),
                                              securityPayload: payload))
        case .special:
            SpecialComponent()
        case .discuss:
            DiscussComponent().listen(to: command)
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
