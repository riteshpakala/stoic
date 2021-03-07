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
    
    var envSettings: EnvironmentStyle.Settings = .init()
}

extension EnvironmentStyle {
    public struct Settings: Equatable {
        public struct LocalFrame: Equatable {
            let data: CGRect
        }
        
        var lf: LocalFrame? = nil
    }
}
