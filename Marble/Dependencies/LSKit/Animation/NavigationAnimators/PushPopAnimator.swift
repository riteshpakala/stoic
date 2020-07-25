//
//  PushPopAnimator.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/15/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class PushPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationController.Operation
    let fromRight: Bool
    let fromBottom: Bool
    
    init(operation: UINavigationController.Operation, fromRight : Bool = true, fromBottom : Bool = false) {
        self.operation = operation
        self.fromRight = fromRight
        self.fromBottom = fromBottom
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)!
        let to   = transitionContext.viewController(forKey: .to)!
        
        let rightTransform = CGAffineTransform(translationX: fromBottom ? 0 : (fromRight ? 1 : -1 )*transitionContext.containerView.bounds.size.width, y: fromBottom ? (fromBottom ? 1 : -1 )*transitionContext.containerView.bounds.size.height : 0)
        let leftTransform = CGAffineTransform(translationX: fromBottom ? 0 : (fromRight ? -1 : 1 )*transitionContext.containerView.bounds.size.width, y: fromBottom ? (fromBottom ? -1 : 1 )*transitionContext.containerView.bounds.size.height : 0)
        
        if operation == .push {
            to.view.transform = rightTransform
            transitionContext.containerView.addSubview(to.view)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                from.view.transform = leftTransform
                to.view.transform = .identity
            }, completion: { finished in
                from.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else if operation == .pop {
            to.view.transform = leftTransform
            transitionContext.containerView.insertSubview(to.view, belowSubview: from.view)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                to.view.transform = .identity
                from.view.transform = rightTransform
            }, completion: { finished in
                from.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
