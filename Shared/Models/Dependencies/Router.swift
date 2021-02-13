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
    lazy var router: Router = {
        _router as? Router ?? .init()
    }()
    
    lazy var environment: EnvironmentDependency = {
        return router.dependencies.get(EnvironmentDependency.self) ?? .init()
    }()
    
    var authState: AuthState = .none
}

public class Router: GraniteRouter {
    public var route: GraniteRoute = Route.home//.debug(.models)
    
    public var children: [GraniteAdAstra] = []
    public lazy var dependencies: [DependencyManager] = [
        EnvironmentDependency.init(self)
    ]
    
    required public init() {
//        self.env.router = self
    }
    
//    public func request(_ route: GraniteRoute) {
//        GraniteLogger.info("requesting route \(route.target)\nself:\(String(describing: self))", .dependency, focus: true)
//
//        guard let newRoute = route.convert(to: Route.self) else { return }
//
//        self.route = newRoute
//
//
//    }
//
//    public func request(_ route: Route) {
//        self.route = route
//
//        if let child = children.first(where:  { type(of: $0) == route.target }) {
//
//            child.land()
//            GraniteLogger.info("requesting route 2 \(route.target)\nself:\(String(describing: self))", .dependency, focus: true)
//        }
//    }
    
    public func clean() {
//        _env = .init(identifier: "envDependency")
    }
}

extension DependencyManager {
    var fetch: RouterDependency {
        return self as? RouterDependency ?? .init(identifier: "none")
    }
}
