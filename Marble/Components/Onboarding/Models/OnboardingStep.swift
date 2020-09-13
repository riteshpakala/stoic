//
//  OnboardingStep.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class OnboardingProperties: NSObject {
    let backgroundColor: UIColor
    let textColor: UIColor
    let textFont: UIFont
    let textBackgroundColor: UIColor
    
    public init(
        backgroundColor: UIColor,
        textColor: UIColor,
        textFont: UIFont,
        textBackgroundColor: UIColor) {
        
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textFont = textFont
        self.textBackgroundColor = textBackgroundColor
        
        super.init()
    }
}

public protocol OnboardingActionableDelegate: class {
    func commitAction()
}
public class OnboardingActionable: NSObject {
    weak var delegate: OnboardingActionableDelegate? = nil
    public var keyPath: String
    public var view: GraniteBaseView
    public var observer: NSKeyValueObservation? = nil
    public var KVOContext: UniChar = UUID.init().uuidString.map({ UniChar.init(String($0)) ?? 0 }).reduce(0, +);
    private var isObserving: Bool = false
    public var order: Int = 0
    public init<ValueType>(
        keyPath: KeyPath<GraniteBaseView, ValueType>,
        view: GraniteBaseView) {
        
        self.keyPath = NSExpression.init(forKeyPath: keyPath).keyPath
        self.view = view
        
        super.init()
        
    }
    
    public func activate() {
        self.view.addObserver(
            self,
            forKeyPath: self.keyPath,
            options: .new,
            context: &KVOContext)
        
        isObserving = true
    }
    
    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        
        self.delegate?.commitAction()
    }
    
    public func removeObservers() {
        guard isObserving else { return }
        view.removeObserver(self, forKeyPath: keyPath, context: &KVOContext)
        self.observer?.invalidate()
    }
    
    deinit {
        removeObservers()
    }
}

public class OnboardingStep: NSObject, OnboardingActionableDelegate {
    weak var delegate: OnboardingActionableDelegate?
    let reference: OnboardingReference?
    var isActionable: Bool {
        actionable != nil
    }
    let actionable: OnboardingActionable?
    var hasCommittedAction: Bool = false
    let isEmpty: Bool
    let text: String
    let order: Int
    let isContinueHidden: Bool
    
    public init(
        reference: OnboardingReference? = nil,
        actionable: OnboardingActionable? = nil,
        text: String,
        order: Int,
        isEmpty: Bool = false,
        isContinueHidden: Bool = true) {
        
        self.reference = reference
        self.text = text
        self.order = order
        self.isEmpty = isEmpty
        self.actionable = actionable
        self.isContinueHidden = isContinueHidden
        super.init()
        
        self.actionable?.order = order
        self.actionable?.delegate = self
    }
    
    public func commitAction() {
        hasCommittedAction = true
        delegate?.commitAction()
    }
    
    public func removeObservers() {
        self.delegate = nil
        self.actionable?.removeObservers()
    }
    
    static public var empty: OnboardingStep {
        OnboardingStep.init(
            reference: .init(referenceView: .init()),
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
        
        if paddingPreferred {
            origin.x = padding.left
            origin.y = padding.top
        } else {
            origin.x -= padding.left
            origin.y -= padding.top
        }
        
        return .init(
            origin: origin,
            size: .init(
                width: self.referenceView.frame.size.width + padding.right,
                height: self.referenceView.frame.size.height + padding.bottom))
    }
    let containerView: UIView?
    let fitsToBounds: Bool
    let padding: UIEdgeInsets
    let textPadding: CGFloat
    let paddingPreferred: Bool
    public init(
        referenceView: UIView = .init(),
        containerView: UIView? = nil,
        fitsToBounds: Bool = false,
        padding: UIEdgeInsets = .zero,
        paddingPreferred: Bool = false,
        textPadding: CGFloat = 0) {
        self.referenceView = referenceView
        self.containerView = containerView
        self.fitsToBounds = fitsToBounds
        self.padding = padding
        self.textPadding = textPadding
        self.paddingPreferred = paddingPreferred
    }
}
