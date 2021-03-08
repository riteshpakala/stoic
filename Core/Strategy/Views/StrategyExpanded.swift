//
//  StrategyExpanded.swift
//  stoic (iOS)
//
//  Created by Ritesh Pakala on 3/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

struct StrategyExpanded: View, GraniteEventResponder {
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
    
    func colorFor(_ item: Strategy.Investments.Item.Change) -> Color {
        if item.isTestable {
            return Brand.Colors.marble
        } else {
            return Brand.Colors.white
        }
    }
    
    public var body: some View {
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
                                    investment(item)
                                        .padding(.leading, Brand.Padding.medium)
                                        .padding(.trailing, Brand.Padding.medium)
                                    
                                    PaddingVertical(Brand.Padding.xSmall)
                                    
                                }
                                
                            }
                        }
                    }
                    
                }.frame(maxWidth: .infinity,
                        maxHeight: .infinity)
                .animation(.default)
            }
        }
    }
    
    public func investment(_ item: Strategy.Investments.Item) -> some View {
        VStack(spacing: Brand.Padding.medium) {
            HStack(alignment: .center) {
                GradientView(colors: [Brand.Colors.greyV2.opacity(0.66),
                                      Brand.Colors.grey.opacity(0.24)],
                             cornerRadius: 6.0,
                             direction: .topLeading)
                    .frame(
                        width: 75,
                        height: 36,
                        alignment: .center)
                    .overlay (
                        VStack {
                            GraniteText(item.ticker.uppercased(),
                                        item.closed ? Brand.Colors.marble : Brand.Colors.black,
                                        .title3,
                                        .bold)
                        }
                    
                    )
                    .background((item.closed ? Brand.Colors.black : item.statusColor).cornerRadius(6.0)
                                    .shadow(color: Color.black, radius: 6.0, x: 3.0, y: 2.0))
                
                VStack(alignment: .leading) {
                    if item.closed {
                        GraniteText("closed",
                                    Brand.Colors.marble,
                                    .footnote,
                                    .bold,
                                    .leading,
                                    addSpacers: false)
                    }
                    
                    GraniteText(item.companyName,
                                item.closed ? Brand.Colors.marble : Brand.Colors.white,
                                .subheadline,
                                .regular,
                                .leading,
                                addSpacers: false)
                }
                
                Spacer()
            }.padding(.bottom, Brand.Padding.small)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: columns, spacing: Brand.Padding.large) {
                    ForEach(item.listChanges.reversed(), id: \.date) { change in
                        
                        VStack {
                            
                            GraniteText(change.date.asStringWithTime,
                                        colorFor(change),
                                        .subheadline,
                                        .regular)
                        
                            HStack {
                                VStack(alignment: .trailing) {
                                    
                                    GraniteText(change.amount.display,
                                                colorFor(change),
                                                .headline,
                                                .regular,
                                                .trailing,
                                                addSpacers: false)
                                    
                                    GraniteText(item.changePercent(change).statusPercentDisplay,
                                                colorFor(change),
                                                .subheadline,
                                                .bold,
                                                .trailing,
                                                addSpacers: false)
                                }
                                
                                PaddingHorizontal(Brand.Padding.xSmall, Brand.Colors.purple)
                                
                                VStack(alignment: .leading) {
                                    GraniteText("upper: 400",
                                                Brand.Colors.purple,
                                                .footnote,
                                                .regular,
                                                .leading,
                                                addSpacers: false)
                                    
                                    GraniteText("lower: 400",
                                                Brand.Colors.purple,
                                                .footnote,
                                                .regular,
                                                .leading,
                                                addSpacers: false)
                                    
                                    GraniteText("buy***",
                                                Brand.Colors.purple,
                                                .subheadline,
                                                .bold,
                                                .leading,
                                                addSpacers: false)
                                }
                            }
                        }
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                    }
                }
            }
            .scaleEffect(x: -1, y: 1, anchor: .center)
            .frame(height: 66)
            
            
            HStack {
                GraniteText("data: \(item.changes.count)",
                            Brand.Colors.marble,
                            .footnote,
                            .regular,
                            .trailing)
            }
        }
        .padding(.top, Brand.Padding.xMedium)
        .padding(.bottom, Brand.Padding.small)
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
}
