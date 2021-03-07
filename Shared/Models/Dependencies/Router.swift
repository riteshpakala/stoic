//
//  Router.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

class RouterDependency: GraniteRouterDependable {
    var router: Router = .init()
    var authState: AuthState = .none
}

public class Router: GraniteRouter {
    public var route: GraniteRoute = Route.home
    public var home: GraniteAdAstra? = nil
    
    required public init() {}
    
    public func request(_ route: GraniteRoute) {
        guard let newRoute = route.convert(to: Route.self) else { return }

        self.route = newRoute
    }

    public func loading(component: GraniteAdAstra?) {
        print("{TEST} loading \(component)")
    }
    
    public func closing(component: GraniteAdAstra?) {
        print("{TEST} closing \(component)")
    }
    
    public func request(_ route: Route) {
        self.route = route
        
        home?.toTheStars()
                    
        GraniteLogger.info("requesting route 2 \nself:\(String(describing: self))",
                           .dependency,
                           focus: true)
    }
    
    public func clean() {}
}

class StoicDependencies: GraniteDependencyManager {
    private let router: RouterDependency
    private let environment: EnvironmentDependency
    private let tone: ToneDependency
    private let detail: DetailDependency
    private let discuss: DiscussDependency
    private let broadcasts: BroadcastDependency
    
    init() {
        self.router = .init()
        self.environment = .init()
        self.tone = .init()
        self.detail = .init()
        self.discuss = .init()
        self.broadcasts = .init()
        addDependencies()
    }
    
    private func addDependencies() {
        let resolver = GraniteResolver.shared
        
        resolver.add(router)
        resolver.add(environment)
        resolver.add(tone)
        resolver.add(detail)
        resolver.add(discuss)
        resolver.add(broadcasts)
    }
}

//class RouterDependency: DependencyManager {
//    lazy var router: Router = {
//        _router as? Router ?? .init()
//    }()
//
//    lazy var environment: EnvironmentDependency = {
//        return router.dependencies.get(EnvironmentDependency.self) ?? .init()
//    }()
//
//    var authState: AuthState = .none
//}
//

