//
//  Discuss.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/3/21.
//

import Foundation
import GraniteUI
import SwiftUI

class Discuss {
    var state: DiscussState = .init()
    var server: DiscussServiceModels.IRCServer? = nil
    
    var channel: String {
        state.currentChannel
    }
}
