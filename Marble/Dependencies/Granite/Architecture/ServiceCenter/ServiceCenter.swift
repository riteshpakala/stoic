//
//  ServiceCenter.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class ComponentNode {
    var data: AnyComponent?
    var parent: ComponentNode?
}

public class ServiceCenter {
    static let shared = ServiceCenter()
    
    static var instances: [AnyComponent] = []
    static var chains: [ComponentNode] = []
    
    static func attach(
        _ component: AnyComponent,
        toComponent parentComponent: AnyComponent) {
        
        instances.append(component)
        
        for (i, node) in chains.enumerated() {
            if node.parent?.data?.id == parentComponent.id {
                let newNode: ComponentNode = .init()
                newNode.data = component
                newNode.parent = node
                chains[i] = newNode
            }
        }
    }
}
