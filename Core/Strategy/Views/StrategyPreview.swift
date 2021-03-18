//
//  StrategyPreview.swift
//  stoic (iOS)
//
//  Created by Ritesh Pakala on 3/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

struct StrategyPreview: View, GraniteEventResponder {
    public var command: GraniteCommand<StrategyCenter, StrategyState>
    
    let parentColumns = [
        GridItem(.flexible()),
    ]
    let columns = [
        GridItem(.flexible()),
    ]
    
    let strategies: [Strategy]
    let state: StrategyState
    
    public init(command: GraniteCommand<StrategyCenter, StrategyState>) {
        self.state = command.state
        self.strategies = command.center.strategies
        self.command = command
    }
    
    public var body: some View {
            
            VStack {
                VStack {
                    GraniteText("strategy",
                                .headline,
                                .bold,
                                .leading)
                                .shadow(color: .black,
                                        radius: 2,
                                        x: 1,
                                        y: 1)
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
            
                VStack {
                    ForEach(strategies, id: \.self) { strategy in
                        VStack(spacing: 0) {
                            
                            title(strategy)
                                .padding(.bottom, Brand.Padding.medium9)
                                .padding(.leading, Brand.Padding.medium)
                                .padding(.trailing, Brand.Padding.medium)
                            
                            PaddingVertical(Brand.Padding.xSmall)
                            
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 0) {
                                    ForEach(strategy.investments.items, id: \.self) { item in
                                        
                                        VStack {
                                            if item.closed {
                                                closed(item)
                                                .padding(.top, Brand.Padding.medium)
                                                .padding(.leading, Brand.Padding.xMedium)
                                                .padding(.trailing, Brand.Padding.xMedium)
                                                .padding(.bottom, Brand.Padding.medium)
                                            } else {
                                                header(item)
                                                .padding(.top, Brand.Padding.medium)
                                                .padding(.leading, Brand.Padding.xMedium)
                                                .padding(.trailing, Brand.Padding.xMedium)
                                                .padding(.bottom, Brand.Padding.medium)
                                                
                                                PaddingVertical(Brand.Padding.xSmall)
                                                
                                                info(item)
                                            }
                                            
                                        }.background(GradientView(colors: item.closed ? [Brand.Colors.black,
                                                                           Brand.Colors.marble.opacity(0.24)] : [Brand.Colors.marbleV2,
                                                                           Brand.Colors.marble],
                                                                  direction: .topLeading)
                                                        .shadow(color: Color.black, radius: 6.0, x: 2.0, y: 3.0))
                                                        .padding(.bottom, Brand.Padding.small)
                                                        .padding(.top, Brand.Padding.medium)
                                    }
                                }
                                .padding(.leading, Brand.Padding.medium)
                                .padding(.trailing, Brand.Padding.medium)
                            }
                            
                        }.frame(maxWidth: .infinity,
                                maxHeight: .infinity)
                        .animation(.default)
                    }
                }.frame(maxWidth: .infinity,
                        maxHeight: .infinity)
                .opacity(state.stage == .syncing ? 0.75 : 1.0)
            }
            .clipped()
            .padding(.top, Brand.Padding.medium)
    }
    
    public func title(_ strategy: Strategy) -> some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: Brand.Padding.medium9) {
                GraniteText(strategy.name,
                            Brand.Colors.white,
                            .title2,
                            .bold,
                            .leading)
                
                GraniteText("ends \(strategy.endDate.simple.asString) [\(strategy.endDate.daysFrom(Date.today))]",
                            Brand.Colors.purple,
                            .subheadline,
                            .regular,
                            .leading,
                            verticalAlignment: .top)
            }
                
            VStack(alignment: .trailing, spacing: Brand.Padding.xMedium) {
                HStack {
                    VStack(alignment: .center) {
                        GraniteText(state.statusLabel,
                                    Brand.Colors.yellow,
                                    .subheadline,
                                    .regular,
                                    .trailing)
                    }
                    
                    if state.stage != .syncing {
                        GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                            colors: [Brand.Colors.yellow,
                                                                     Brand.Colors.purple],
                                                            selected: true,
                                                            size: .init(16),
                                                            padding: .init(0,
                                                                           Brand.Padding.medium9,
                                                                           0,
                                                                           Brand.Padding.medium9),
                                                            action: {
                                                                GraniteHaptic.light.invoke()
                                                                sendEvent(StrategyEvents.Sync())
                                                            }))
                    } else {
                        GraniteText("\(state.syncProgress.percentRounded)%",
                                    Brand.Colors.yellow,
                                    .subheadline,
                                    .bold)
                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                    }
                    
                }
                
                GraniteText("reset",
                            Brand.Colors.redBurn,
                            .subheadline,
                            .bold,
                            .trailing)
                    .shadow(color: Color.black,
                            radius: 1.0, x: 1.0, y: 2.0)
                    .modifier(TapAndLongPressModifier.init(tapAction: {
                        
                        set(\.showResetDisclaimer, value: true)
                        
                    } ))
                
            }
        }
    }
    
    public func closed(_ item: Strategy.Investments.Item) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: Brand.Padding.medium) {
                    GraniteText(item.ticker.uppercased(),
                                Brand.Colors.black,
                                .title3,
                                .bold,
                                style: .init(gradient: [Brand.Colors.marbleV2.opacity(0.75),
                                                        Brand.Colors.marble.opacity(0.36)]))
                    
                    
                    GraniteText("closed",
                                Brand.Colors.marble,
                                .headline,
                                .bold)
                }
                .padding(.top, Brand.Padding.small)
                .padding(.leading, Brand.Padding.small)
                
                Spacer()
                
                GraniteText("company name",
                            Brand.Colors.marble,
                            .headline,
                            .bold)
                
                GraniteText("\(item.companyName)",
                            Brand.Colors.marble,
                            .subheadline,
                            .regular)
            }
            
            Spacer()
            VStack(alignment: .leading, spacing: Brand.Padding.xSmall) {
                
                GraniteText("$\(item.closedAmount.display)",
                            .subheadline,
                            .bold)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                                
                GraniteText(item.closedPercent.statusPercentDisplay,
                            .footnote,
                            .bold)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                
                
                GraniteText("\(item.closedDate.asString)",
                            .footnote,
                            .regular)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .background(item.closedStatusColor
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 4, x: 1, y: 2))
        }
    }
    
    public func header(_ item: Strategy.Investments.Item) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                GraniteText("company name",
                            Brand.Colors.black,
                            .headline,
                            .bold)
                
                GraniteText("\(item.companyName)",
                            Brand.Colors.black,
                            .subheadline,
                            .regular)
                
                GraniteText("opened",
                            Brand.Colors.black,
                            .headline,
                            .bold)
                            .padding(.top, Brand.Padding.small)
                
                GraniteText(item.date.asStringWithTime,
                            Brand.Colors.black,
                            .subheadline,
                            .regular)
            }
            
            VStack(alignment: .trailing) {
                GraniteText(item.ticker.uppercased(),
                            .title3,
                            .bold,
                            .trailing,
                            style: .init(gradient: [Color.black.opacity(0.75),
                                                    Color.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.small)
                
                Spacer()
                
                HStack(spacing: Brand.Padding.medium) {
                    GraniteText("remove",
                                Brand.Colors.redBurn,
                                .headline,
                                .bold)
                        .shadow(color: Color.black,
                                radius: 1.0, x: 1.0, y: 2.0)
                        .modifier(TapAndLongPressModifier.init(tapAction: {
                            set(\.wantsToRemove, value: item)
                        } ))
                    
                    
                    GraniteText("close",
                                Brand.Colors.yellow,
                                .headline,
                                .bold)
                        .shadow(color: Color.black,
                                radius: 1.0, x: 1.0, y: 2.0)
                        .modifier(TapAndLongPressModifier.init(tapAction: {
                            set(\.wantsToClose, value: item)
                        } ))
                }
                
            }
        }
    }
    
    public func info(_ item: Strategy.Investments.Item) -> some View {
        HStack(spacing: Brand.Padding.medium) {
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText("$\(item.meta.initial.amount.display)",
                            .subheadline,
                            .bold,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                                
                GraniteText("\(item.meta.initial.date.asString)",
                            .footnote,
                            .bold,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                
                
                GraniteText("initial",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .background(Brand.Colors.black
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 4, x: 1, y: 2))
            
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText("$\(item.lastValue.display)",
                            .subheadline,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                                
                GraniteText(item.latestChangePercent.statusPercentDisplay,
                            .footnote,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                
                
                GraniteText("\(item.latestChange.date.asString)",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .background(item.statusColor
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 4, x: 1, y: 2))
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText(item.tonalSummary,
                            .subheadline,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                
                
                GraniteText(item.tonalGoal,
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .background(Brand.Colors.purple
                            .opacity(0.57)
                            .cornerRadius(6.0)
                            .shadow(color: .black, radius: 4, x: 1, y: 2))
            
        }
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
    }
}
