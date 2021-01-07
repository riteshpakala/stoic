//
//  Environment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

class EnvironmentDependency: DependencyManager {
    @ObservedObject
    var home: Home = .init()
    
    @ObservedObject
    var tone: Tone = .init()
    
    @ObservedObject
    var search: SearchQuery = .init()
}

extension DependencyManager {
    var env: EnvironmentDependency {
        return self as? EnvironmentDependency ?? .init(identifier: "none")
    }
}
