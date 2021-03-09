//
//  StrategyComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StrategyComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<StrategyCenter, StrategyState> = .init()
    
    public init() {}
    
    public var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                GradientView(colors: [Brand.Colors.yellow,
                                      Brand.Colors.purple],
                             cornerRadius: 0.0,
                             direction: .top)
                            .shadow(color: Color.black,
                                    radius: 8.0,
                                    x: 4.0,
                                    y: 3.0)
                            .offset(x: 0,
                                    y: (geometry.size.height*(1.0 - (state.syncProgress.isNaN ? 0.0 : state.syncProgress.asCGFloat))))
                            .animation(.default)
            }
            VStack(spacing: 0) {
                switch state.type {
                case .preview:
                    StrategyPreview(command: command)
                    
                    PaddingVertical(Brand.Padding.xSmall)
                    HStack(alignment: .center) {
                        Spacer()
                        GraniteButtonComponent(
                            state: .init("detail",
                                        padding: .init(Brand.Padding.medium,
                                                       0,
                                                       Brand.Padding.medium,
                                                       0),
                                        action: route(Route.strategyDetail)))
                        Spacer()
                        GraniteButtonComponent(
                            state: .init("+",
                                        padding: .init(Brand.Padding.medium,
                                                       0,
                                                       Brand.Padding.medium,
                                                       0),
                                        action: {
                                            GraniteHaptic.light.invoke()
                                            set(\.stage, value: .adding)
                                        }))
                        Spacer()
                    }
                case .expanded:
                    HStack(alignment: .center, spacing: Brand.Padding.medium) {
                        GraniteButtonComponent(
                            state: .init("export",
                                        padding: .init(0,
                                                       0,
                                                       0,
                                                       0),
                                        action: {}))
                        
                        Spacer()
                        
                            
                        Image("logo_small")
                            .resizable()
                            .frame(width: 42,
                                   height: 42,
                                   alignment: .center)
                    }
                    .padding(.top, Brand.Padding.xSmall)
                    .padding(.leading, Brand.Padding.medium)
                    .padding(.trailing, Brand.Padding.medium9)
                    
                    StrategyExpanded(command: command)
                        .padding(.top, Brand.Padding.large)
                    
                    GraniteButtonComponent(
                        state: .init(.add,
                                     padding: .init(0,0,0,0),
                                     action: {
                                       GraniteHaptic.light.invoke()
                                       set(\.stage, value: .adding)
                                     }))
                        .background(Brand.Colors.black)
                default:
                    EmptyView().hidden()
                    
                }
            }
            .padding(.top, Brand.Padding.medium9)
            .padding(.bottom, Brand.Padding.xSmall)
                
                
            if state.stage == .syncing {
                GraniteDisclaimerComponent(state:
                                            .init("please wait, * stoic is\nsyncing the quotes\nin your strategy", opacity: 0.57))
            }
            
            if state.showResetDisclaimer {
                GraniteDisclaimerComponent(state:
                                            .init("are you sure you want to reset your strategy dates?", opacity: 0.57,
                                           action: {
                                            GraniteHaptic.light.invoke()
                                            sendEvent(StrategyEvents.Reset())
                                           },
                                           cancel:{
                                             GraniteHaptic.light.invoke()
                                             set(\.showResetDisclaimer, value: false)
                                           }))
            }
            
            if state.showRemoveDisclaimer {
                GraniteDisclaimerComponent(state:
                                            .init("are you sure you want to remove \(state.wantsToRemove?.ticker.uppercased() ?? "") from your strategy?", opacity: 0.57,
                                           action: {
                                            if let item = state.wantsToRemove {
                                                GraniteHaptic.light.invoke()
                                                sendEvent(StrategyEvents.Remove(assetID: item.assetID))
                                            }
                                           },
                                           cancel:{
                                             GraniteHaptic.light.invoke()
                                             set(\.wantsToRemove, value: nil)
                                           }))
            }
            
            if state.showCloseDisclaimer {
                GraniteDisclaimerComponent(state:
                                            .init("are you sure you want to remove \(state.wantsToClose?.ticker.uppercased() ?? "") from your strategy? Current status will remain in your strategy to keep track of your total net during the strategy's duration", opacity: 0.57,
                                           action: {
                                            if let item = state.wantsToClose {
                                                GraniteHaptic.light.invoke()
                                                sendEvent(StrategyEvents.Close(assetID: item.assetID))
                                            }
                                           },
                                           cancel:{
                                             GraniteHaptic.light.invoke()
                                             set(\.wantsToClose, value: nil)
                                           }))
            }
            
            if state.showOutdatedDisclaimer {
                GraniteDisclaimerComponent(state:
                                            .init("your strategy is out of date. After you export your results, tap reset to begin your next strategy", opacity: 0.57,
                                           action: {
                                            GraniteHaptic.light.invoke()
                                            set(\.showOutdatedDisclaimer, value: false)
                                           }))
            }
            
            if state.stage == .adding {
                VStack {
                    GraniteModal(content: {
                        HoldingsComponent(state: .init(context: .strategy(.none)))
                    }, onExitTap: {
                        set(\.stage, value: .none)
                    })
                }
            }
            
            if state.stage == .choosingModel {
                VStack {
                    GraniteModal(content: {
                        TonalModelsComponent(state: .init(inject(\.envDependency,
                                                                 target: \.tonalModels),
                                                          securityPayload: .init(object: state.pickingModelForSecurity)))
                                                    .listen(to: command, .stop)
                    }, onExitTap: {
                        set(\.stage, value: .none)
                    })
                }
            }
        }
        .clipped()
    }
}

//MARK: -- Empty State Settings
extension StrategyComponent {
    
    public var emptyText: String {
        "create strategies from your \ncurrently held stocks or crypto\n\n* stoic models will then\nguide your investments"
    }
    
    //TODO: poor choice to conditionally show strategy
    public var isDependancyEmpty: Bool {
        command.center.strategiesAreEmpty
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.purple, Brand.Colors.yellow])
    }
}
