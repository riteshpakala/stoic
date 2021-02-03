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
    
    @State var selection: Set<Int> = [0]
    
    @State var showMembers = true
}

//MARK: -- View
extension DiscussComponent {
    // Label("INFORMATION", systemImage: "info")
    public var body: some View {
        ZStack {
            MainView(showMembers: $showMembers,
                     messages: state.messages,
                     message: _state.currentMessage,
                     onMessageSend:  {
                        sendEvent(DiscussRelayEvents.Messages.Send.init(message: state.currentMessage), .contact)
                        let messages = state.messages
                        let message = DiscussMessage
                            .init(color: Brand.Colors.yellow,
                                  data: .init(username: command.center.user.username,
                                              message: state.currentMessage,
                                              channel: state.currentChannel,
                                              date: .today,
                                              messageType: .channel))
                        set(\.messages, value: messages + [message])
                        set(\.currentMessage, value: "")
                     })
        }
    }
    
    struct MainView: View {
        @Binding var showMembers: Bool
        var messages: [DiscussMessage]
        @Binding var message: String
        var onMessageSend: (() -> ())
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Channel(messages: messages,
                            showMembers: $showMembers,
                            message: $message,
                            onMessageSend: onMessageSend)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    struct Channel: View {
        var messages: [DiscussMessage]
        
        @Binding var showMembers: Bool
        @Binding var message: String
        var onMessageSend: (() -> ())
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages, id: \.self) { message in
                                Message(data: message)
                                    .frame(height: 48)
                            }
                        }
                        .padding()
                    }
                    
                    MessageBar(message: $message,
                               onMessageSend: onMessageSend)
                               .frame(height: 57)
                }
                
                //ZStack....
//                if showMembers {
//                    MemberList()
//                }
                
            }.background(Color.black)
        }
    }
    
    struct MemberList: View {
        var colors = [
            Color.red,
            Color.orange,
            Color.yellow,
            Color.green,
            Color.blue,
            Color.purple
        ]
        
        var body: some View {
            List{
                Text("ADMIN - 1")
                    .font(.caption)
                HStack {
                    ZStack {
                        Image("pfp")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 35, height: 35, alignment: .leading)
                    }
                    VStack(alignment: .leading) {
                        Text("code_pranav").font(.headline)
                        Text("Playing Xcode").font(.callout).foregroundColor(.gray)
                    }
                    Spacer()
                }
                Text("ONLINE - 2")
                    .font(.caption)
                HStack {
                    ZStack {
                        Circle()
                            .trim(from:0, to: 1)
                            .foregroundColor(colors.randomElement())
                            .frame(width: 35, height: 35)
                        Image("discordwhite")
                            .resizable()
                            .frame(width:25, height: 18)
                    }
                    VStack(alignment: .leading) {
                        Text("astral lexus").font(.headline)
                        Text("Playing Twitter").font(.callout).foregroundColor(.gray)
                    }
                    Spacer()
                }
                HStack {
                    ZStack {
                        Circle()
                            .trim(from:0, to: 1)
                            .foregroundColor(colors.randomElement())
                            .frame(width: 35, height: 35)
                        Image("discordwhite")
                            .resizable()
                            .frame(width:25, height: 18)
                    }
                    VStack(alignment: .leading) {
                        Text("username").font(.headline)
                        Text("Playing Twitter").font(.callout).foregroundColor(.gray)
                    }
                    Spacer()
                }
            }.frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity).background(Color.init(.sRGB, red: 235/255, green: 237/255, blue: 239/255, opacity: 1.0))
        }
    }
    
    struct Message: View {
        var data: DiscussMessage
        
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
//                    Circle()
//                        .trim(from:0, to: 1)
//                        .foregroundColor(data.color)
//                        .frame(width: 40, height: 40)
                    
                    Rectangle()
                        .frame(width:35, height: 25)
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
                              onCommit: {})// onMessageSend)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .frame(height: 42)
                        .padding(.top, Brand.Padding.small)
                        .padding(.bottom, Brand.Padding.small)
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
