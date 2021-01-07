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
}

public class Router: ObservableObject {
    var route: Route = .home//.debug(.models)
}
