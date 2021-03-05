//
//  __stoicApp.swift
//  Shared
//
//  Created by Ritesh Pakala on 12/18/20.
//

import SwiftUI
import GraniteUI

@main
struct __stoicApp: App {
    
    private let manager = GraniteDependencyManagerTest()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Brand.Colors.black.frame(maxWidth: .infinity,
                                         maxHeight: .infinity,
                                         alignment: .center).edgesIgnoringSafeArea(.all)
                
                ContentView()
            }
        }
    }
}
