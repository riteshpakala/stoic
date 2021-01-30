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
    var search: SearchQuery = .init()
}

public class SearchQuery {
    var state: AssetSearchState
    
    var securityGroup: SecurityGroup = .init()
    
    public init(_ state: AssetSearchState = .init()) {
        self.state = state
    }
}
