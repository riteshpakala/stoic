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
    @ObservedObject
    var router: Router = .init()
    
    public override init(identifier: String,
                         adAstra: GraniteAdAstra? = nil) {
        super.init(identifier: identifier, adAstra: adAstra)
        
        router.root = adAstra
    }
}

public class Router: ObservableObject {
    var route: Route = .home//.debug(.models)
    
    var root: GraniteAdAstra? = nil
    var env: EnvironmentDependency = .init(identifier: "envDependency")
    var envState: EnvironmentState = .init()
    
    public init() {
        self.env.router = self
        print("{TEST} -- \(route)")
    }
    
    public func request(_ route: Route) {
        print("{TEST} \(route) \(env.adAstra)")
        self.route = route
        self.root?.toTheStars(target: nil, .here)
    }
}

extension DependencyManager {
    var fetch: RouterDependency {
        return self as? RouterDependency ?? .init(identifier: "none")
    }
}
