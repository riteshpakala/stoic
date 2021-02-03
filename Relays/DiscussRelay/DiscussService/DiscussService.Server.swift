//
//  DiscussService.Server.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//

import Foundation
import GraniteUI

extension DiscussService {
    public func connect(user: DiscussServiceModels.IRCUser) {
        self.server = DiscussServiceModels
            .IRCServer
            .connect("ec2-54-176-70-40.us-west-1.compute.amazonaws.com",
                     port: 6697,
                     user: user,
                     session: session)
    }
}

extension DiscussServiceModels {
    public struct User {
        let username: String
        let channel: String
    }
    
    public class IRCServer {
        weak var connection: GraniteConnection? {
            didSet {
                guard let connection = connection else {
                    return
                }
                
                channels.forEach { channel in
                    channel.connection = connection
                }
                
                buffer.forEach { (line) in
                    connection.request(DiscussRelayEvents.Messages.Receive.init(payload: .message(line)))
                }
                buffer = []
            }
        }
        
        private var buffer = [String]()
        private var session: URLSession
        private var task: URLSessionStreamTask!
        private var channels = [DiscussServiceModels.IRCChannel]()
        
        public required init(hostname: String, port: Int, user: IRCUser, session: URLSession) {
            self.session = session
            
            task = session.streamTask(withHostName: hostname, port: port)
            task.resume()
            read()
            
            send("USER \(user.username) \(user.uid) * :\(user.realName)<\(user.email)>")
            send("NICK \(user.nick)")
        }
        
        public class func connect(_ hostname: String, port: Int, user: IRCUser, session: URLSession = URLSession.shared) -> Self {
            return self.init(hostname: hostname, port: port, user: user, session: session)
        }
        
        private func read() {
            task.readData(ofMinLength: 0, maxLength: 9999, timeout: 0) { (data, atEOF, error) in
                guard let data = data, let message = String(data: data, encoding: .utf8) else {
                    return
                }
                
                for line in message.split(separator: "\r\n") {
                    self.processLine(String(line))
                }
                self.read()
            }
        }
        
        private func processLine(_ message: String) {
            let input = IRCServerInputParser.parseServerMessage(message)
            switch input {
            case .serverMessage(_, let message):
                if let connection = self.connection {
                    connection.request(DiscussRelayEvents
                                        .Messages
                                        .Receive
                                        .init(payload: .message(message)))
                } else {
                    self.buffer.append(message)
                }
            case .joinMessage(let user, let channelName):
                self.channels.forEach({ (channel) in
                    if channel.name == channelName {
                        connection?.request(DiscussRelayEvents
                                                .Server
                                                .UserJoined
                                                .init(user: DiscussServiceModels
                                                        .User.init(username: user,
                                                                   channel: channelName)))
                    }
                })
            case .channelMessage(let channelName, let user, let message):
                self.channels.forEach({ (channel) in
                    if channel.name == channelName {
                        connection?.request(DiscussRelayEvents
                                                .Messages
                                                .Receive
                                                .init(payload: .init(username: user,
                                                                     message: message,
                                                                     channel: channelName,
                                                                     date: .today,
                                                                     messageType: .channel)))
                    }
                })
            case .userList(let channelName, let users):
                self.channels.forEach({ (channel) in
                    if channel.name == channelName {
                        connection?.request(DiscussRelayEvents
                                                .Server
                                                .UserList
                                                .init(users: users.map {
                                                        DiscussServiceModels
                                                            .User
                                                            .init(username: $0,
                                                                  channel: channelName)
                                                }))
                    }
                })
            case .registered(_):
                if let connection = self.connection {
                    connection.request(DiscussRelayEvents.Client.Registered.init())
                }
            default:
                break
            }
        }
        
        public func send(_ message: String) {
            task.write((message + "\r\n").data(using: .utf8)!, timeout: 0) { [weak self] (error) in
                if let error = error {
                    GraniteLogger.info("\(error)", .utility, focus: true)
                } else {
                    self?.connection?.request(DiscussRelayEvents.Messages.Receive.init(payload: .message("sent command \(message)")))
                }
            }
        }
        
        public func join(_ channelName: String) -> IRCChannel? {
            self.channels.removeAll(where: { $0.name == channelName })
//            guard !self.channels.map({ $0.name }).contains(channelName) else {
//                return nil
//            }
            send("JOIN #\(channelName)")
            let channel = IRCChannel(name: channelName, server: self)
            channel.connection = connection
            channels.append(channel)
            return channel
        }
    }
}
