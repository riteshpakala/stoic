//
//  Discuss.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/3/21.
//

import Foundation
import GraniteUI
import SwiftUI

class DiscussDependency: GraniteInjectable {
    var discuss: Discuss = .init()
}

class Discuss {
    var server: DiscussServiceModels.IRCServer? = nil
    var channel: String = "general"
}
