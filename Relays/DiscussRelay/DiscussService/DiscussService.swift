//
//  DiscussService.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//

import GraniteUI
import Foundation
import Combine

public class DiscussService {
    internal let session: URLSession
    internal var server: DiscussServiceModels.IRCServer?
    weak internal var connection: GraniteConnection? {
        didSet {
            server?.connection = connection
        }
    }
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
}

public struct DiscussServiceModels {
    public struct IRCUser {
        public let username: String
        public let realName: String
        public let uid: String
        public let email: String
        public let nick: String
        
        public init(username: String, realName: String, nick: String, email: String, uid: String) {
            self.username = username
            self.realName = realName
            self.nick = nick
            self.email = email
            self.uid = uid
        }
    }

}

public protocol DiscussServerDelegate {
    func didRecieveMessage(_ server: DiscussServiceModels.IRCServer, message: String)
}


public protocol DiscussChannelDelegate {
    func didRecieveMessage(_ channel: DiscussServiceModels.IRCChannel, message: String)
}
