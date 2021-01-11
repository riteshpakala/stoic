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
    
    public override init(identifier: String, adAstra: GraniteAdAstra? = nil) {
        super.init(identifier: identifier, adAstra: adAstra)
        
        router.root = adAstra
    }
}

public class Router: ObservableObject {
    var route: Route = .floor//.debug(.models)
    
    var root: GraniteAdAstra? = nil
    var env: EnvironmentDependency = .init(identifier: "envDependency")
    
    public init() {
        self.env.router = self
    }
    
    public func request(_ route: Route) {
        self.route = route
        self.root?.toTheStars(target: nil, .here)
    }
}

extension DependencyManager {
    var fetch: RouterDependency {
        return self as? RouterDependency ?? .init(identifier: "none")
    }
}
