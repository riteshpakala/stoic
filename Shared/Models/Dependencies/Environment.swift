//
//  Environment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import Foundation
import GraniteUI
import SwiftUI

class EnvironmentDependency: GraniteDependable {
    var home: Home = .init()

    var tonalModels: TonalModelsState = .init()
    
    var user: User = .init()
    
    var floorStage: FloorStage = .none

    var strategiesPortfolio: StrategyState = .init()
    
    var envSettings: EnvironmentStyle.Settings = .init()
}

extension EnvironmentStyle {
    public struct Settings {
        public struct LocalFrame {
            let data: CGRect
        }
        
        var lf: LocalFrame? = nil
    }
}
