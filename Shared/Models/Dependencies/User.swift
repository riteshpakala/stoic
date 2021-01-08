//
//  User.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//

import Foundation
import GraniteUI
import SwiftUI

class UserDependency: DependencyManager {
    @ObservedObject
    var profile: Profile = .init()
}

extension DependencyManager {
    var user: UserDependency {
        return self as? UserDependency ?? .init(identifier: "none")
    }
}
