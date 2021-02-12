//
//  DiscussRelayEvents.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//
import GraniteUI
import SwiftUI
import Combine

struct DiscussRelayEvents {
    public struct Client {
        public struct Set: GraniteEvent {
            let user: UserInfo
            
            public var beam: GraniteBeamType {
                .rebound
            }
            
            public struct Result: GraniteEvent {
                let server: DiscussServiceModels.IRCServer
                
                public var beam: GraniteBeamType {
                    .rebound
                }
                
                public var behavior: GraniteEventBehavior {
                    .quite
                }
            }
        }
        
        public struct Reconnect: GraniteEvent {
            let server: DiscussServiceModels.IRCServer
            let channel: String
            
            public var beam: GraniteBeamType {
                .rebound
            }
        }
        
        public struct Registered: GraniteEvent {
        }
        
        public struct Listen: GraniteEvent {
            let listener: GraniteConnection
            
            public var beam: GraniteBeamType {
                .broadcast
            }
        }
    }
    
    public struct Server {
        public struct UserJoined: GraniteEvent {
            let user: DiscussServiceModels.User
        }
        
        public struct UserList: GraniteEvent {
            let users: [DiscussServiceModels.User]
        }
    }
    
    public struct Channel {
        public struct Join: GraniteEvent {
            let name: String
        }
    }
    
    public struct Messages {
        public enum MessageType {
            case server
            case channel
        }
        
        public struct Send: GraniteEvent {
            let message: DiscussMessage
            
            public var beam: GraniteBeamType {
                .broadcast
            }
            
            public var behavior: GraniteEventBehavior {
                .quite
            }
        }
        
        public struct Result: GraniteEvent {
            let payload: Receive.Payload
        }
        
        public struct Receive: GraniteEvent {
            public struct Payload: Identifiable, Hashable {
                let username: String
                let message: String
                let channel: String
                let date: Date
                let messageType: MessageType
                let id: String = UUID().uuidString
                
                static func message(_ message: String) -> Payload {
                    return self.init(username: "", message: message, channel: "", date: .today, messageType: .server)
                }
                
                public var asString: String {
                    """
                    [ New Message \(messageType == .channel ? "in #\(channel)" : "from Server") ]
                    \(messageType == .channel ? "username: \(username)" : "")
                    message: \(message)
                    date: \(date)
                    """
                }
            }
            
            let payload: Payload
            
            public var beam: GraniteBeamType {
                .broadcast
            }
            
            public var behavior: GraniteEventBehavior {
                .quite
            }
        }
    }
}
