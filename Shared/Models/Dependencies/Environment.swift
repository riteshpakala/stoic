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
    var detail: Detail = .init()
    
    @ObservedObject
    var tone: Tone = .init()
    
    @ObservedObject
    var user: User = .init()
    
    var floor: Floor = .init()
    
    @ObservedObject
    var searchTone: SearchQuery = .init(.init(.tonalCreate(.none)))
    
    @ObservedObject
    var search: SearchQuery = .init(.init(.search))
    
    @ObservedObject
    var searchAdd: SearchQuery = .init(.init(.portfolio))
    
    @ObservedObject
    var broadcasts: Broadcasts = .init()
    
    weak var router: Router? = nil
}

extension DependencyManager {
    var env: EnvironmentDependency {
        return self as? EnvironmentDependency ?? .init(identifier: "none")
    }
}
