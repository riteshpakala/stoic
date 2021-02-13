//
//  DiscussService.Parser.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//

import Foundation

extension DiscussServiceModels {
    struct IRCServerInputParser {
        static func parseServerMessage(_ message: String) -> IRCServerInput {
            if message.hasPrefix("PING") {
                return .ping
            }
            
            if message.hasPrefix(":") {
                let firstSpaceIndex = message.firstIndex(of: " ")!
                let source = message[..<firstSpaceIndex]
                let rest = message[firstSpaceIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if rest.hasPrefix("PRIVMSG") {
                    let remaining = rest[rest.index(message.startIndex, offsetBy: 8)...]
                    
                    if remaining.hasPrefix("#") {
                        let split = remaining.components(separatedBy: ":")
                        let channel = split[0].trimmingCharacters(in: CharacterSet(charactersIn: " #"))
                        let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                        let message = split[1]
                        
                        return .channelMessage(channel: channel, user: user, message: message)
                    }
                } else if rest.hasPrefix("JOIN") {
                    let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                    let channel = rest[rest.index(message.startIndex, offsetBy: 5)...].trimmingCharacters(in: CharacterSet(charactersIn: ":#"))
                    return .joinMessage(user: user, channel: channel)
                } else if rest.hasPrefix("PART") {
                    let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                    let channel = rest[rest.index(message.startIndex, offsetBy: 5)...].trimmingCharacters(in: CharacterSet(charactersIn: ":#"))
                    return .leftMessage(user: user, channel: channel)
                } else if rest.hasPrefix("QUIT") {
                    let user = source.components(separatedBy: "!")[0].trimmingCharacters(in: CharacterSet(charactersIn: ":"))
                    return .quitMessage(user: user)
                } else {
                    let components = message.components(separatedBy: "\r\n")
                    
                    let namesListIndex = components.firstIndex(where: { $0.contains(":End of /NAMES list.") }) ?? 0
                    
                    if namesListIndex > 0 && components.count > 1 {
                        var users: [(channel: String, users: [String])] = []
                        for i in 0..<namesListIndex {
                            var segments = components[i].components(separatedBy: ":")
                            let userList = segments.removeLast()
                            let channel = segments.last?.components(separatedBy: "#").last?.trimmingCharacters(in: .whitespacesAndNewlines)
                            if userList.isNotEmpty,
                               let channelFound = channel {
                                let usersParsed = userList.components(separatedBy: .whitespacesAndNewlines).filter { $0.isNotEmpty }
                                users.append((channelFound, usersParsed))
                            }
                        }
                        
                        if users.isNotEmpty, let list = users.first {
                            return .userList(channel: list.channel, users: list.users)
                        }
                    } else if message.contains(":your unique ID") {
                        return .registered(user: rest.components(separatedBy: ":").first ?? rest)
                    } else {
                        let server = source.trimmingCharacters(in: CharacterSet(charactersIn: ": "))
                        
                        return .serverMessage(server: server, message: "* discuss initialized")
                    }
                }
            }
            
            return .unknown(raw: message)
        }
    }
    
    enum IRCServerInput: Equatable {
        case unknown(raw: String)
        case ping
        case serverMessage(server: String, message: String)
        case channelMessage(channel: String, user: String, message: String)
        case joinMessage(user: String, channel: String)
        case leftMessage(user: String, channel: String)
        case quitMessage(user: String)
        case userList(channel: String, users: [String])
        case registered(user: String)
        
        
        
        static func ==(lhs: IRCServerInput, rhs: IRCServerInput) -> Bool{
            switch (lhs, rhs) {
            case (.ping, .ping):
                return true
            case (.channelMessage(let lhsChannel, let lhsUser, let lhsMessage),
                  .channelMessage(let rhsChannel, let rhsUser, let rhsMessage)):
                return lhsChannel == rhsChannel && lhsMessage == rhsMessage && lhsUser == rhsUser
            case (.serverMessage(let lhsServer, let lhsMessage),
                  .serverMessage(let rhsServer, let rhsMessage)):
                return lhsServer == rhsServer && lhsMessage == rhsMessage
            case (.joinMessage(let lhsUser, let lhsChannel), .joinMessage(let rhsUser, let rhsChannel)):
                return lhsUser == rhsUser && lhsChannel == rhsChannel
            case (.leftMessage(let lhsUser, let lhsChannel), .leftMessage(let rhsUser, let rhsChannel)):
                return lhsUser == rhsUser && lhsChannel == rhsChannel
            case (.quitMessage(let lhsUser), .quitMessage(let rhsUser)):
                return lhsUser == rhsUser
            case (.userList(let lhsChannel, let lhsUsers), .userList(let rhsChannel, let rhsUsers)):
                return lhsChannel == rhsChannel && lhsUsers == rhsUsers
            case (.registered(let lhsUser), .registered(let rhsUser)):
                return lhsUser == rhsUser
            default:
                return false
            }
        }
    }
}
