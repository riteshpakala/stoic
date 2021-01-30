//
//  Router.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

class RouterDependency: DependencyManager {
    var router: Router = .init()
    
    public override init(identifier: String,
                         adAstra: GraniteAdAstra? = nil) {
        super.init(identifier: identifier, adAstra: adAstra)
        
        router.root = adAstra
    }
}

public class Router {
    var route: Route = .home//.debug(.models)
    
    var root: GraniteAdAstra? = nil
    var env: EnvironmentDependency = .init(identifier: "envDependency")
    var envState: EnvironmentState = .init()
    
    public init() {
        self.env.router = self
    }
    
    public func request(_ route: Route) {
        GraniteLogger.info("requesting route \(route)\nself:\(String(describing: self))", .dependency)
        self.route = route
        self.root?.toTheStars(target: nil, .here)
    }
}

extension DependencyManager {
    var fetch: RouterDependency {
        return self as? RouterDependency ?? .init(identifier: "none")
    }
}
