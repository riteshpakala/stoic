//
//  Builder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit


class Builder<S: State> {
    var state: S
    
    init(state: S) {
        self.state = state
    }
    
    func prepareBuild(
        _ services: Services,
        _ viewController: UIViewController) -> Component<S> {
        
        return .init(services, state, viewController)
    }
}

