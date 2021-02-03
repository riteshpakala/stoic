//
//  User.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//

import Foundation
import GraniteUI
import SwiftUI

class User {
    var info: UserInfo = .empty 
    
    var portfolio: Portfolio? = nil
    
    var portfolioExpandedState: PortfolioState = .init(.expanded)
}

public struct UserInfo {
    var username: String
    var email: String
    var created: Date
    var uid: String
    
    static var empty: UserInfo {
        return .init(username: "", email: "", created: .today, uid: "")
    }
    
    public var isReady: Bool {
        self.username.isNotEmpty && self.email.isNotEmpty
    }
}
