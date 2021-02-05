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
                                
                                GraniteText("ends in \(strategy.endDate.daysFrom(strategy.date)) days",
                                            Brand.Colors.purple,
                                            .subheadline,
                                            .regular,
                                            .trailing)
                            }
                            .padding(.bottom,
                                     Brand.Padding.medium)
                        }
                        
                        PaddingVertical(Brand.Padding.xSmall).padding(.bottom, Brand.Padding.medium)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: Brand.Padding.large) {
                                ForEach(strategy.quotes, id: \.quoteID) { quote in
                                    
                                        VStack {
                                            
                                            VStack {
                                                GraniteText("company name: \(quote.name)",
                                                            Brand.Colors.black,
                                                            .subheadline,
                                                            .bold,
                                                            .leading)
                                                            .padding(.top, Brand.Padding.small)
                                                
                                                GraniteText("exchange name: \(quote.exchangeName)",
                                                            Brand.Colors.black,
                                                            .subheadline,
                                                            .bold,
                                                            .leading)
                                            }
                                            .padding(.top, Brand.Padding.medium)
                                            .padding(.leading, Brand.Padding.large)
                                            .padding(.trailing, Brand.Padding.large)
                                            .padding(.bottom, Brand.Padding.medium)
                                            
                                            HStack(spacing: Brand.Padding.large) {
                                                
                                                VStack(spacing: Brand.Padding.xSmall) {
                                                    GraniteText("\(quote.ticker.uppercased())",
                                                                .title2,
                                                                .bold,
                                                                .leading)
                                                                .shadow(color: .black,
                                                                        radius: 2, x: 2, y: 2)
                                                    
                                                    GraniteText("$\(quote.latestValue.display)",
                                                                .headline,
                                                                .bold,
                                                                .leading)
                                                                .shadow(color: .black,
                                                                        radius: 2, x: 2, y: 2)
                                                                    
                                                    GraniteText("\(quote.latestChangePercent.percent)% \(quote.latestIsGainer ? "^" : "")",
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
                                                    GraniteText("\(quote.ticker.uppercased())",
                                                                .title2,
                                                                .bold,
                                                                .leading)
                                                        .shadow(color: .black,
                                                                radius: 2, x: 2, y: 2)
                                                    
                                                    GraniteText("$\(quote.latestValue.display)",
                                                                .headline,
                                                                .bold,
                                                                .leading)
                                                        .shadow(color: .black,
                                                                radius: 2, x: 2, y: 2)
                                                                    
                                                    GraniteText("\(quote.latestChangePercent.percent)% \(quote.latestIsGainer ? "^" : "")",
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
                                            
    //                                        Color.black.overlay(
    //                                                    GraniteText(quote.name,
    //                                                                Brand.Colors.white,
    //                                                                .subheadline,
    //                                                                .regular)
    //                                            )
    //                                            .frame(maxWidth: .infinity,
    //                                                   minHeight: 75,
    //                                                   maxHeight: 120,
    //                                                   alignment: .center)
    //                                            .cornerRadius(8)
    //                                            .shadow(color: .black, radius: 4, x: 2, y: 2)
    //                                            .onTapGesture(perform: {} )
                                            
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
