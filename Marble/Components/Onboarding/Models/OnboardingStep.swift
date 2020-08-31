//
//  OnboardingStep.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class OnboardingStep: NSObject {
    let reference: OnboardingReference?
    let isActionable: Bool
    var hasCommittedAction: Bool = false
    let isEmpty: Bool
    let text: String
    let order: Int
    
    public init(
        reference: OnboardingReference? = nil,
        isActionable: Bool,
        text: String,
        order: Int,
        isEmpty: Bool = false) {
        
        self.reference = reference
        self.isActionable = isActionable
        self.text = text
        self.order = order
        self.isEmpty = isEmpty
    }
    
    static public var empty: OnboardingStep {
        OnboardingStep.init(
            reference: .init(referenceView: .init()),
            isActionable: false,
            text: "error",
            order: 0,
            isEmpty: true)
    }
}

public class OnboardingReference: NSObject {
    let referenceView: UIView
    var referenceFrame: CGRect {
        var origin: CGPoint = referenceView.frame.origin
        
        if fitsToBounds {
            if self.referenceView.frame.origin.x < 0 {
                origin.x = 0
            }
            if self.referenceView.frame.origin.y < 0 {
                origin.y = 0
            }
        }
        
        if let containerView = containerView {
            origin.x += containerView.frame.origin.x
            origin.y += containerView.frame.origin.y
        }
        
        origin.x -= padding.left
        origin.y -= padding.top
        return .init(
            origin: origin,
            size: .init(
                width: self.referenceView.frame.size.width + padding.right,
                height: self.referenceView.frame.size.height + padding.bottom))
    }
    let containerView: UIView?
    let fitsToBounds: Bool
    let padding: UIEdgeInsets
    public init(
        referenceView: UIView,
        containerView: UIView? = nil,
        fitsToBounds: Bool = false,
        padding: UIEdgeInsets = .zero) {
        self.referenceView = referenceView
        self.containerView = containerView
        self.fitsToBounds = fitsToBounds
        self.padding = padding
    }
}
