//
//  Search.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import Foundation
import SwiftUI
import GraniteUI

class SearchDependency: DependencyManager {
    @ObservedObject
    var search: SearchQuery = .init()
}

class SearchQuery: ObservableObject {
    var state: SearchState = .init()
    var securities: [Security] = []
}
