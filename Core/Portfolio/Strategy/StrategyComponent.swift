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
                    VStack {
                        
                        title(strategy)
                        
                        PaddingVertical(Brand.Padding.xSmall).padding(.bottom, Brand.Padding.medium)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                                ForEach(strategy.investments.items, id: \.self) { item in
                                    
                                        VStack {
                                            
                                            HStack(alignment: .top) {
                                                header(item)
                                                
                                                VStack {
                                                    GraniteText(item.ticker.uppercased(),
                                                                .title3,
                                                                .bold,
                                                                .trailing,
                                                                style: .init(gradient: [Color.black.opacity(0.75),
                                                                                        Color.black.opacity(0.36)]))
                                                        .padding(.top, Brand.Padding.small)
                                                    
                                                    Spacer()
                                                    
                                                    GraniteText("close position",
                                                                Brand.Colors.redBurn,
                                                                .headline,
                                                                .bold,
                                                                .trailing)
                                                        .shadow(color: Color.black,
                                                                radius: 1.0, x: 1.0, y: 2.0)
                                                        .modifier(TapAndLongPressModifier.init(tapAction: {} ))
                                                }
                                            }
                                            .padding(.top, Brand.Padding.medium)
                                            .padding(.leading, Brand.Padding.large)
                                            .padding(.trailing, Brand.Padding.large)
                                            .padding(.bottom, Brand.Padding.medium)
                                            
                                            PaddingVertical(Brand.Padding.xSmall)
                                            
                                            info(item)
                                            
                                        }.background(GradientView(colors: [Brand.Colors.marbleV2,
                                                                           Brand.Colors.marble],
                                                                  direction: .topLeading)
                                                        .shadow(color: Color.black, radius: 8.0, x: 4.0, y: 3.0))
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
            HStack {
                GraniteText(strategy.name,
                            Brand.Colors.white,
                            .title2,
                            .bold,
                            .leading)
                            .padding(.bottom,
                                     Brand.Padding.medium)
                
                VStack {
                    GraniteText("\(strategy.endDate.simple.asString)",
                                Brand.Colors.purple,
                                .headline,
                                .bold,
                                .trailing)
                    
                    GraniteText("ends in \(strategy.endDate.daysFrom(Date.today)) days",
                                Brand.Colors.purple,
                                .subheadline,
                                .regular,
                                .trailing)
                }
                .padding(.bottom,
                         Brand.Padding.medium)
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
                GraniteText("initial",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                
                GraniteText("$\(item.initial.amount.display)",
                            .headline,
                            .bold,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                                
                GraniteText("\(item.initial.date.asString)",
                            .subheadline,
                            .bold,
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
                GraniteText("\(item.latestChange.date.asString)",
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                
                GraniteText("$\(item.lastValue.display)",
                            .headline,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                                
                GraniteText(item.latestChangePercent.statusPercentDisplay,
                            .subheadline,
                            .bold,
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
                GraniteText(item.tonalTargetDate.asString,
                            .footnote,
                            .regular,
                            .leading)
                            .shadow(color: .black,
                                    radius: 2, x: 2, y: 2)
                
                GraniteText(item.tonalSummary,
                            .headline,
                            .bold,
                            .leading)
                    .shadow(color: .black,
                            radius: 2, x: 2, y: 2)
                
                GraniteText("\(item.tonalAccuracy)",
                            .subheadline,
                            .bold,
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
