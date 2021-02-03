//
//  DiscussService.Channel.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//

import Foundation
import GraniteUI

extension DiscussServiceModels {
    public struct Message {
        let data: String
        let channel: String
        let username: String
    }
    
    public class IRCChannel {
        public var connection: GraniteConnection? = nil {
            didSet {
                guard let connection = connection else {
                    return
                }
                
                buffer.forEach { (line) in
                    connection.request(DiscussRelayEvents.Messages.Receive.init(payload: .message(line)))
                }
                buffer = []
            }
        }
        public let name: String
        public let server: DiscussServiceModels.IRCServer
        private var buffer = [String]()
        public var isPrepared: Bool = false
        
        public init(name: String, server: DiscussServiceModels.IRCServer) {
            self.name = name
            self.server = server
        }
        
        
        func receive(_ text: String) {
            if let connection = self.connection {
                connection.request(DiscussRelayEvents.Messages.Receive.init(payload: .message(text)))
            } else {
                buffer.append(text)
            }
        }
        
        public func send(_ text: String) {
            server.send("PRIVMSG #\(name) :\(text)")
        }
    }
}
