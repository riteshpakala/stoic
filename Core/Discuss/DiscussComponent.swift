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
import Discuss

public struct DiscussComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<DiscussCenter, DiscussState> = .init()
    
    public init() {
        
        client.connect()
        client.delegate = self
        client.sendMessage(IRCMessage.init(command: .JOIN(channels: [IRCChannelName.init("#general")!], keys: nil)))
        
    }
    
    open class Options : IRCClientOptions {
        
        open var thinkingTime   : TimeInterval = 2.0
        open var sessionTimeout : TimeInterval = 2 * 60.0
        
        override public init(port           : Int             = 6697,
                             host           : String          = "ec2-54-176-70-40.us-west-1.compute.amazonaws.com",
                             password       : String?         = nil,
                             nickname       : IRCNickName,
                             userInfo       : IRCUserInfo?    = nil,
                             eventLoopGroup : EventLoopGroup? = nil)
        {
            super.init(port: port,
                       host: host,
                       password: password,
                       nickname: nickname,
                       userInfo: userInfo,
                       eventLoopGroup: eventLoopGroup)
        }
    }
    
    lazy var client: IRCClient = {
        .init(options: Options.init(nickname: IRCNickName.init("zion")!))
    }()
    
    @State var selection: Set<Int> = [0]
    
    @State var showMembers = true
}

extension DiscussComponent: IRCClientDelegate {
    public func client(_ client: IRCClient, registered nick: IRCNickName,
                       with userInfo: IRCUserInfo) {
        
        
        
        print("\(nick.stringValue) is ready and listening!")
    }
    public func client(_ client: IRCClient, received message: IRCMessage) {}
    
    public func clientFailedToRegister(_ client: IRCClient) {}
    
    public func client(_ client: IRCClient, messageOfTheDay: String) {}
    public func client(_ client: IRCClient,
                       notice message: String,
                       for recipients: [ IRCMessageRecipient ]) {}
    public func client(_ client: IRCClient,
                       message: String, from sender: IRCUserID,
                       for recipients: [ IRCMessageRecipient ]) {}
    public func client(_ client: IRCClient, changedUserModeTo mode: IRCUserMode) {}
    public func client(_ client: IRCClient, changedNickTo nick: IRCNickName) {}
    
    public func client(_ client: IRCClient,
                       user: IRCUserID, joined channels: [ IRCChannelName ]) {}
    public func client(_ client: IRCClient,
                       user: IRCUserID, left   channels: [ IRCChannelName ],
                       with message: String?) {}
    public func client(_ client: IRCClient,
                       changeTopic: String, of channel: IRCChannelName) {}
    
    
}

//MARK: -- View
extension DiscussComponent {
    // Label("INFORMATION", systemImage: "info")
    public var body: some View {
        ZStack {
            MainView(showMembers: $showMembers)
        }
    }
    
    struct MainView: View {
        @Binding var showMembers: Bool
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Channel(showMembers: $showMembers)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    struct Channel: View {
        @State var messages = [
            "Here’s to the crazy ones",
            "the misfits, the rebels, the troublemakers",
            "the round pegs in the square holes…",
            "the ones who see things differently — they’re not fond of rules…",
            "You can quote them, disagree with them, glorify or vilify them",
            "but the only thing you can’t do is ignore them because they change things…",
            "they push the human race forward",
            "and while some may see them as the crazy ones",
            "we see genius",
            "because the ones who are crazy enough to think that they can change the world",
            "are the ones who do."
        ]
        
        @Binding var showMembers: Bool
        
        var body: some View {
            HStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages, id: \.self) { message in
                                Message(text: message)
                            }
                        }
                        .padding()
                    }
                    
                    MessageBar()
                }
                
                if showMembers {
                    MemberList()
                }
                
            }
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
        @State var text: String
        var names = [
            "astral lexus",
            "code_pranav",
            "username",
            "itsjack123",
            "fieryfox999"
        ]
        var colors = [
            Color.red,
            Color.orange,
            Color.yellow,
            Color.green,
            Color.blue,
            Color.purple
        ]
        
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .trim(from:0, to: 1)
                        .foregroundColor(colors.randomElement())
                        .frame(width: 40, height: 40)
                    Image("discordwhite")
                        .resizable()
                        .frame(width:35, height: 25)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(names.randomElement()!)
                            .font(.headline)
                            .foregroundColor(colors.randomElement())
                        
                        Text("9:41 AM")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(text)
                        .font(.body)
                        .fontWeight(.regular)
                }
                
                Spacer()
            }
        }
    }
    
    struct MessageBar: View {
        
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            VStack(spacing: 0) {
                Divider()
                HStack {
                    Image(systemName: "plus.circle.fill").padding()
                        .font(.title)
                    Text("Message #general").foregroundColor(.gray)
                        .font(.title2)
                    Spacer()
                    Image(systemName: "gift.fill").padding()
                        .font(.title)
                    Image(systemName: "photo.fill").padding()
                        .font(.title)
                    Image(systemName: "face.smiling").padding()
                        .font(.title)
                }.background(colorScheme == .light ? Color.init(.sRGB, red: 235/255, green: 237/255, blue: 239/255, opacity: 1.0) : Color.init(.sRGB, red: 64/255, green: 68/255, blue: 75/255, opacity: 1.0)).cornerRadius(10.0).padding(10)
                
            }
            .foregroundColor(.secondary)
        }
    }
}
