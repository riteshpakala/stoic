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
    
    //Property wrapped injectable dependencies
    //should exist at the most top-level component
    //of an aplicatino interface. In this project
    //its `App`
    private let dependencies = StoicDependencies()
    
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
