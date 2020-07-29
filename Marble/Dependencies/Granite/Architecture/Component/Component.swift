//
//  Component.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol AnyComponent {
    var parent: AnyComponent? { get set }
    var reducers: [AnyReducer] { get }
    var subComponents: [AnyComponent] { get set }
    var id: String { get }
    var stateType: State.Type { get }
    var viewController: UIViewController? { get set }
    func build()
    func processEvent(_ event: Event)
    func processBubbleEvent(_ event: Event)
    var observers: [NSKeyValueObservation?] { get set }
    func rip()
}

public class Component<S: State>: AnyComponent {
    var observers: [NSKeyValueObservation?] = []
    
    var reducers: [AnyReducer] {
        return []
    }
    
    internal var parent: AnyComponent? = nil
    var subComponents: [AnyComponent] = []
    
    var services: Services
    var state: S
    
    public var viewController: UIViewController?
    public var graniteController: GraniteViewController<S>?
    public var id: String
    
    private var hasRipped: Bool = false
    
    init(
        _ services: Services,
        _ state: S,
        _ viewController: UIViewController? = nil,
        parent: AnyComponent? = nil) {
        
        self.services = services
        self.state = state
        self.graniteController = viewController as? GraniteViewController<S>
        self.viewController = viewController
        self.parent = parent
        id = NSUUID().uuidString
        build()
        
        didLoad()
    }
    
    func didLoad() {
        
    }
    
    func rip() {
        subComponents.forEach { component in
            component.rip()
        }
        
        hasRipped = true
    }
}

extension Component {
    
    public var stateType: State.Type {
        return S.self
    }
    
    public func build() {
        self.graniteController?.bind(self)
    }
    
    func getSubComponent(
        _ componentType: Any? = nil,
        id: String? = nil) -> AnyComponent? {
        var component: AnyComponent? = nil
        
        for componentToCheck in self.subComponents {
            
            if let id = id {
                if componentToCheck.id == id {
                    component = componentToCheck
                    break
                }
            } else if let componentType = componentType {
                let componentToCheckMirror = Mirror(reflecting: componentToCheck)
                
                if type(of: componentType) == type(of: componentToCheckMirror.subjectType) {
                    component = componentToCheck
                    break
                }
            }
        }
        
        return component
    }
}

extension Component {
    func observeState<ValueType>(
        _ keyPath: KeyPath<S, ValueType>,
        handler: @escaping (_ value: Change<ValueType>) -> Void,
        async: DispatchQueue? = nil) {
        let observer = state.observe(
        keyPath,
        options: .new) { (_, value) in
            guard let threadToRun = async else {
                handler(value)
                return
            }
            threadToRun.async {
                handler(value)
            }
        }
        observers.append(observer)
    }
}

extension Component {
    
    func push(
        _ component: AnyComponent?,
        fit: Bool = false) {
        
        guard let componentCheck = component else {
            if services.debug {
                print("⚠️ Failed to push component, component not found.")
            }
            return
        }
        componentCheck.build()
        self.attach(componentCheck)
        if fit {
            componentCheck.viewController?
                .view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func pop(
        _ component: AnyComponent?) {
        
    }
    
    func attach(_ component: AnyComponent) {
        subComponents.append(component)
        
        guard component.viewController != nil else {
            if services.debug {
                print("⚠️ Failed to attach component controller, viewController not found.")
            }
            return
        }
        
        viewController?.addChild(component.viewController!)
        viewController?.view.addSubview(component.viewController!.view)
    }
    
    func deattach(_ component: AnyComponent) {
        for observer in component.observers {
            observer?.invalidate()
        }
        
        subComponents.removeAll { $0.viewController == component.viewController }
        
        component.rip()
        
        guard component.viewController != nil else { return }
        
        component.viewController!.willMove(toParent: nil)
        component.viewController!.view.removeFromSuperview()
        component.viewController!.removeFromParent()
    }
    
    func allReducers() -> [AnyReducer] {
        var reducers = self.reducers
        subComponents.forEach { component in
            reducers.append(contentsOf: component.reducers)
        }
        
        return reducers
    }
}

extension Component {
    // TODO: Completion handlers
    //       threading~
    //
    public func processEvent(
        _ event: Event) {
        guard !hasRipped else { return }
        var mutableComponent: AnyComponent = self
        var mutableState: State = self.state
        
        var sideEffects: [EventBox] = []
        if  let reducer = allReducers().first(
            where: { $0._eventType == type(of: event) }) {
            
            reducer.execute(
                event: event,
                state: &mutableState,
                sideEffects: &sideEffects,
                component: &mutableComponent)
        }
        
        if let stateCheck = mutableState as? S {
            self.state = stateCheck
        } else if services.debug {
            print("⚠️ State was unable to persist.")
        }
        
        if let componentCheck = mutableComponent as? Self {
            self.subComponents = componentCheck.subComponents
            self.services = componentCheck.services
        }
        
        sideEffects.forEach { box in
            processEvent(box.event)
        }
    }
    
    public func processBubbleEvent(
        _ event: Event) {
        guard !hasRipped else { return }
        if  !executeEvent(event),
            let parentComponent = self.parent{
            
            parentComponent.processBubbleEvent(event)
        } else if services.debug {
            print("⚠️ End of bubble chain for \(type(of: event))")
        }
    }
    
    func executeEvent(_ event: Event) -> Bool {
        var mutableComponent: AnyComponent = self
        var mutableState: State = self.state
        
        var sideEffects: [EventBox] = []
        if  let reducer = allReducers().first(
            where: { $0._eventType == type(of: event) }) {
            
            reducer.execute(
                event: event,
                state: &mutableState,
                sideEffects: &sideEffects,
                component: &mutableComponent)
        } else {
            return false
        }
        
        if let stateCheck = mutableState as? S {
            self.state = stateCheck
        } else {
            print("⚠️ State was unable to persist.")
        }
        
        if let componentCheck = mutableComponent as? Self {
            self.subComponents = componentCheck.subComponents
            self.services = componentCheck.services
        }
        
        sideEffects.forEach { box in
            box.async.async {
                _ = self.executeEvent(box.event)
            }
        }
        
        return true
    }
}
