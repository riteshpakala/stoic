//
//  BaseViewController.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class GraniteBaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class GraniteViewController<S: State>: GraniteBaseViewController {
    let feedbackGenerator: UIImpactFeedbackGenerator = .init()
    
    var component: Component<S>?
    var observers: [NSKeyValueObservation?] = []
    
    public func bind(_ component: Component<S>) {
        self.component = component
    }
    
    func observeState<ValueType>(
        _ keyPath: KeyPath<S, ValueType>,
        handler: @escaping (_ value: Change<ValueType>) -> Void,
        async: DispatchQueue? = nil) {
        let observer = component?.state.observe(
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
    
    deinit {
        for observer in observers {
            observer?.invalidate()
        }
    }
}

extension GraniteViewController: EventResponder {
    public func sendEvent(_ event: Event) {
        component?.processEvent(event)
    }
    
    public func bubbleEvent(_ event: Event) {
        component?.processBubbleEvent(event)
    }
}
