//
//  Profile.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//

import Foundation
import GraniteUI
import SwiftUI

class Profile: ObservableObject {
    var username: String = "Michael Burry"
    
    @ObservedObject
    var holdings: Holdings = .init()
}
