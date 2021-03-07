//
//  DiscussComponent.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct DiscussComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<DiscussCenter, DiscussState> = .init()
    
    public init() {}
}

//MARK: -- View
extension DiscussComponent {
    // Label("INFORMATION", systemImage: "info")
    public var body: some View {
        ZStack {
            MainView(safeAreaPadding: command.center.environmentSafeArea,
                     users: state.users,
                     messages: state.messages,
                     message: _state.currentMessage,
                     onMessageSend: sendEvent(DiscussEvents.Send()))
           
            
            if EnvironmentConfig.isIPhone {
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        
                        GraniteButtonComponent(state: .init(.image("profile_icon"),
                                                            selected: true,
                                                            size: .init(16),
                                                            padding: .init(Brand.Padding.xxMedium,
                                                                           0,
                                                                           0,
                                                                           Brand.Padding.large),
                                                            action: {
                                                 GraniteHaptic.light.invoke()
                                                 set(\.showMembers, value: true)
                                             }))
                    }
                    
                    
                    Spacer()
                }
                
                if state.showMembers {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            GraniteButtonComponent(
                                state: .init(.addNoSeperator,
                                             padding: .init(0,0,Brand.Padding.xSmall,0),
                                             action: {
                                               GraniteHaptic.light.invoke()
                                                set(\.showMembers, value: false)
                                             })).transformEffect(.rotation(.init(degrees: 45)))
                        }

                        AssetGridComponent(state: .init(0,
                                                        assetData: state.users))
                            .frame(maxWidth: 240, maxHeight: .infinity).background(Brand.Colors.black)
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                    
                }
            }
        }
    }
    
    struct MainView: View {
        var safeAreaPadding: CGFloat
        var users: [User]
        var messages: [DiscussMessage]
        @Binding var message: String
        var onMessageSend: (() -> ())
        
        let cols = [
            GridItem(.flexible()),
        ]
        
        var body: some View {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    ChannelBrowser(channels: ["general"])
                        .frame(height: 42 + Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                    
                    Channel(safeAreaPadding: safeAreaPadding,
                            messages: messages,
                            message: $message,
                            onMessageSend: onMessageSend)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if !EnvironmentConfig.isIPhone {
                    PaddingHorizontal()
                    
                    AssetGridComponent(state: .init(0,
                                                    assetData: users))
                        .frame(maxWidth: 240, maxHeight: .infinity)
                }
            }
        }
    }
    
    struct ChannelBrowser: View {
        var channels: [String]
        
        let rows = [
            GridItem(.flexible()),
        ]
        
        var body: some View {
            VStack(alignment: .center) {
                ScrollView {
                    LazyHGrid.init(rows: rows, alignment: .center) {
                        ForEach(channels, id: \.self) { channel in
                            VStack(alignment: .center) {
                                Spacer()
                                ZStack {
                                    GradientView(colors: [Color.black, Color.black.opacity(0.0)],
                                                 cornerRadius: 6.0,
                                                 direction: .topLeading).overlay(
                                        
                                        GraniteText("#"+channel,
                                                    .subheadline,
                                                    .bold)
                                    )
                                    .frame(width: 120, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .shadow(color: Color.black, radius: 1, x: 0, y: 1)
                                    
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }.background(Brand.Colors.black)
        }
    }
    
    struct Channel: View {
        var safeAreaPadding: CGFloat
        var messages: [DiscussMessage]
        
        @Binding var message: String
        var onMessageSend: (() -> ())
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages.reversed(), id: \.self) { message in
                                Message(data: message)
                                    .frame(height: 48)
                                    .scaleEffect(x: -1, y: -1, anchor: .center)
                            }
                        }
                        .padding()
                    }
                    .rotationEffect(.degrees(180))
                    
                    #if os(iOS)
                    MessageBar(message: $message,
                               onMessageSend: onMessageSend)
                        .frame(height: 48)
                        .keyboardObserving(offset: -safeAreaPadding)
                    #else
                    
                    MessageBar(message: $message,
                               onMessageSend: onMessageSend)
                        .frame(height: 48)
                    #endif
                }
                
            }.background(Color.black)
        }
    }
    
    struct Message: View {
        var data: DiscussMessage
        
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
                    GradientView(colors: [Brand.Colors.greyV2.opacity(0.66),
                                          Brand.Colors.grey.opacity(0.24)],
                                 cornerRadius: 6.0,
                                 direction: .topLeading)
                        .frame(
                            width: 36,
                            height: 36,
                            alignment: .center)
                        .overlay (
                            VStack {
                                GraniteText("",
                                            Brand.Colors.black,
                                            .title3, .bold)
                            }
                        
                        )
                        .background(data.color.cornerRadius(6.0)
                                        .shadow(color: Color.black,
                                                radius: 6.0,
                                                x: 3.0,
                                                y: 2.0))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(data.data.username)
                            .font(Fonts.live(.subheadline, .bold))
                            .foregroundColor(data.color)
                        
                        Text(data.data.date.asStringWithTime)
                            .font(Fonts.live(.footnote, .regular))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(data.data.message)
                        .font(Fonts.live(.subheadline, .regular))
                        .fontWeight(.regular)
                }
                
                Spacer()
            }
        }
    }
    
    struct MessageBar: View {
        @Binding var message: String
        @Environment(\.colorScheme) var colorScheme
        var onMessageSend: (() -> ())
        
        var body: some View {
            VStack(spacing: 0) {
                Divider()
                HStack {
//                    Image(systemName: "plus.circle.fill").padding()
//                        .font(.title)
                    TextField("Message #general",
                              text: $message,
                              onCommit: onMessageSend)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .frame(height: 36)
                        .padding(.top, Brand.Padding.small)
                        .padding(.bottom, Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .background(Color.clear)
                    Spacer()
//                    Image(systemName: "gift.fill").padding()
//                        .font(.title)
//                    Image(systemName: "photo.fill").padding()
//                        .font(.title)
//                    Image(systemName: "face.smiling").padding()
//                        .font(.title)
                }.background(GradientView(colors: [Brand.Colors.black,
                                                   Brand.Colors.black.opacity(0.0)],
                                                   cornerRadius: 0.0,
                                                   direction: .topLeading))
                
            }
        }
    }
}
