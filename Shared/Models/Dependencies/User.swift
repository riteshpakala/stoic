//
//  User.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//

import Foundation
import GraniteUI
import SwiftUI

class User: ObservableObject {
    
    var portfolio: Portfolio? = nil
    
    var portfolioExpandedState: PortfolioState = .init(.expanded)
    
}

