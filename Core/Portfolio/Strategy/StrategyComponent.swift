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
    
    let parentColumns = [
        GridItem(.flexible()),
    ]
    let columns = [
        GridItem(.flexible()),
    ]
    
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
            
            VStack {
                ForEach(command.center.strategies, id: \.self) { strategy in
                    VStack(spacing: 0) {
                        
                        title(strategy).padding(.bottom, Brand.Padding.medium9)
                        
                        PaddingVertical(Brand.Padding.xSmall)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 0) {
                                ForEach(strategy.investments.items, id: \.self) { item in
                                    
                                    VStack {
                                        HStack(alignment: .top, spacing: 0) {
                                            header(item)
                                            
                                            VStack(alignment: .trailing) {
                                                GraniteText(item.ticker.uppercased(),
                                                            .title3,
                                                            .bold,
                                                            .trailing,
                                                            style: .init(gradient: [Color.black.opacity(0.75),
                                                                                    Color.black.opacity(0.36)]))
                                                    .padding(.top, Brand.Padding.small)
                                                
                                                Spacer()
                                                
                                                GraniteText("close",
                                                            Brand.Colors.redBurn,
                                                            .headline,
                                                            .bold,
                                                            .trailing)
                                                    .shadow(color: Color.black,
                                                            radius: 1.0, x: 1.0, y: 2.0)
                                                    .modifier(TapAndLongPressModifier.init(tapAction: {} ))
                                            }.frame(maxWidth: 75, maxHeight: .infinity)
                                        }
                                        .padding(.top, Brand.Padding.medium)
                                        .padding(.leading, Brand.Padding.xMedium)
                                        .padding(.trailing, Brand.Padding.xMedium)
                                        .padding(.bottom, Brand.Padding.medium)
                                        
                                        PaddingVertical(Brand.Padding.xSmall)
                                        
                                        info(item)
                                        
                                    }.background(GradientView(colors: [Brand.Colors.marbleV2,
                                                                       Brand.Colors.marble],
                                                              direction: .topLeading)
                                                    .shadow(color: Color.black, radius: 8.0, x: 4.0, y: 3.0))
                                                    .padding(.bottom, Brand.Padding.small)
                                                    .padding(.top, Brand.Padding.medium)
                                }
                            }
                        }
                        
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                }
            }.frame(maxWidth: .infinity,
                    maxHeight: .infinity)
            
        }
        .padding(.top, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
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
                        GraniteText("sync",
                                    Brand.Colors.yellow,
                                    .subheadline,
                                    .regular,
                                    .trailing)
                    }
                    
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
                                                        }))
                    
                }
                
                GraniteText("last sync: \(Date.today.asString)",
                            Brand.Colors.marble,
                            .subheadline,
                            .regular,
                            .trailing,
                            verticalAlignment: .top)
                
            }
        }
    }
    
    public func header(_ item: Strategy.Investments.Item) -> some View {
        VStack {
            GraniteText("company name",
                        Brand.Colors.black,
                        .headline,
                        .bold,
                        .leading)
            
            GraniteText("\(item.companyName)",
                        Brand.Colors.black,
                        .subheadline,
                        .regular,
                        .leading)
            
            GraniteText("exchange",
                        Brand.Colors.black,
                        .headline,
                        .bold,
                        .leading)
                        .padding(.top, Brand.Padding.small)
            
            GraniteText("\(item.exchangeName)",
                        Brand.Colors.black,
                        .subheadline,
                        .regular,
                        .leading)
        }
    }
    
    public func info(_ item: Strategy.Investments.Item) -> some View {
        HStack(spacing: Brand.Padding.medium) {
            
            VStack(spacing: Brand.Padding.xSmall) {
                
                GraniteText("$\(item.initial.amount.display)",
                            .subheadline,
                            .bold,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                                
                GraniteText("\(item.initial.date.asString)",
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
                
                GraniteText("\(item.tonalAccuracy)",
                            .footnote,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                
                
                GraniteText(item.tonalTargetDate.asString,
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

//MARK: -- Empty State Settings
extension StrategyComponent {
    
    public var emptyText: String {
        "create strategies from your \ncurrently held stocks or crypto\n\n* stoic models will then\nguide your investments"
    }
    
    public var isDependancyEmpty: Bool {
        command.center.strategies.isEmpty
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.purple, Brand.Colors.yellow])
    }
}
