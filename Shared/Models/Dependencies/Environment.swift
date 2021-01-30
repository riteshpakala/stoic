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
    var home: Home = .init()
    
    var detail: Detail = .init()
    
    var tone: Tone = .init()

    var tonalModels: TonalModelsState = .init()
    
    var user: User = .init()
    
    var searchTone: SearchQuery = .init(.init(.tonalCreate(.none)))
    
    var search: SearchQuery = .init(.init(.search))
    
    var holdingsPortfolio: HoldingsState = .init( .init(.init(.portfolio(.holdings))))
    var holdingsFloor: HoldingsState = .init( .init(.init(.floor)))
    var holdingsStrategy: HoldingsState = .init( .init(.init(.strategy)), type: .radio)

    var strategiesPortfolio: StrategyState = .init()
    
    var broadcasts: Broadcasts = .init()
    
    weak var router: Router? = nil
}

extension DependencyManager {
    var env: EnvironmentDependency {
        return self as? EnvironmentDependency ?? .init(identifier: "none")
    }
}
