//
//  Auth.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//

import Foundation
import GraniteUI
import SwiftUI

public struct Auth {
    var user: StoicUser
    
    public static var empty: Auth {
        return .init(user: .init(username: "", email: "", created: .today))
    }
    
    var isReady: Bool {
        user.email.isNotEmpty && user.username.isNotEmpty
    }
}

public struct StoicUser {
    var username: String
    var email: String
    var created: Date
}
