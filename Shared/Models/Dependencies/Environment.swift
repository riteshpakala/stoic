//
//  Environment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

class EnvironmentDependency2: DependencyManager, GraniteInjectable {
    var home: Home = .init()

    var tonalModels: TonalModelsState = .init()
    
    var user: User = .init()
    
    var floorStage: FloorStage = .none

    var strategiesPortfolio: StrategyState = .init()
    
    var broadcasts: Broadcasts = .init()
    
    var envSettings: EnvironmentStyle.Settings = .init()
}

class EnvironmentDependency: DependencyManager {
    var home: Home = .init()
    
    var detail: Detail = .init()
    
    var discuss: Discuss = .init()
    
    var tone: Tone = .init()

    var tonalModels: TonalModelsState = .init()
    
    var user: User = .init()
    
    var floorStage: FloorStage = .none

    var strategiesPortfolio: StrategyState = .init()
    
    var broadcasts: Broadcasts = .init()
    
    var envSettings: EnvironmentStyle.Settings = .init()
}

extension DependencyManager {
    var env: EnvironmentDependency {
        return self as? EnvironmentDependency ?? .init(identifier: "none")
    }
}

extension EnvironmentStyle {
    public struct Settings {
        public struct LocalFrame {
            let data: CGRect
        }
        
        var lf: LocalFrame? = nil
    }
}
