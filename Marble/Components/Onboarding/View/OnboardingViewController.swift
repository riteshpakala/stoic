//
//  OnboardingViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class OnboardingViewController: GraniteViewController<OnboardingState>, OnboardingViewDelegate {
    
    var reference: Onboardable? {
        return self.component?.parent?.viewController?.view as? Onboardable
    }
    
    override public func loadView() {
        self.view = OnboardingView.init()
    }
    
    public var _view: OnboardingView {
        return self.view as! OnboardingView
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.parent = self.parent?.view
        _view.delegate = self
        
        GraniteAppDelegate.AppUtility.lockToPortrait()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let reference = reference {
            _view.backgroundColor = reference.onboardingProperties.backgroundColor
            _view.onboardingMessage.textColor = reference.onboardingProperties.textColor
            _view.onboardingMessage.font = reference.onboardingProperties.textFont
            _view.onboardingMessage.backgroundColor = reference.onboardingProperties.textBackgroundColor
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        GraniteAppDelegate.AppUtility.toggleLockToLast()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setup(currentStep)
    }
    
    func viewTapped(inRegion: Bool) {
        guard !currentStepIsActionable else {
            return
        }
        
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        var step: OnboardingStep?
        if  !inRegion && !self.currentStep.isActionable {
            step = getNextStep()
        }
        
        guard let nextStep = step else { return }
        reference?.committedStep(self.currentStep.order)
        setup(nextStep)
    }
}

extension OnboardingViewController: OnboardingActionableDelegate {
    public func commitAction() {
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        guard
            currentStepIsActionable,
            currentStepCommittedAction else {
            return
        }
        
        reference?.committedStep(self.currentStep.order)
        setup(getNextStep())
    }
}

extension OnboardingViewController {
    func setup(_ step: OnboardingStep) {
        mask(step)
        applyText(step)
        
        self._view.superview?.bringSubviewToFront(_view)
        
        step.delegate = self
        component?.sendEvent(
            OnboardingEvents.UpdateStep.init(
                step: step,
                index: step.order))
    }
    
    func mask(_ step: OnboardingStep) {
        guard let reference = step.reference else { return }
        let maskLayer = CAShapeLayer()
        maskLayer.frame = _view.layer.bounds
        let highlightPath = UIBezierPath.init(
            roundedRect: reference.referenceFrame,
            cornerRadius: 8)
        let mainPath = UIBezierPath.init(rect: _view.layer.bounds)
        
        mainPath.append(highlightPath)
        maskLayer.path = mainPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        _view.layer.mask = maskLayer
        _view.currentStepRegion = reference.referenceFrame
    }
    
    func applyText(_ step: OnboardingStep) {
        _view.onboardingMessage.text = step.text
        
        guard let reference = reference,
              let referenceFrame = step.reference?.referenceFrame else { return }
        let sizeOfText = _view.onboardingMessage.sizeThatFits(reference.frame.size)
        let heightOfText = sizeOfText.height + 24
        _view.messageHeightConstraint?.update(offset: heightOfText)
        
        //
        //
        let xPadding = step.reference?.containerView?.frame.origin.x ?? 0
        let yPadding = step.reference?.containerView?.frame.origin.y ?? 0
        let rectOfReference: CGRect = CGRect.init(
            origin: .init(
                x: xPadding + referenceFrame.origin.x,
                y: yPadding + referenceFrame.origin.y),
            size: CGSize.init(
                width: referenceFrame.width,
                height: referenceFrame.height))
        let rectOfText = CGRect.init(
            origin: .init(
                x: _view.onboardingMessage.frame.origin.x,
                y: reference.frame.height/2 - (heightOfText/2)),
            size: CGSize.init(
                width: _view.onboardingMessage.frame.size.width,
                height: heightOfText))
        //
        //
        
        var positioning: CGFloat
        
        if rectOfReference.intersects(rectOfText) {
            let intersection = rectOfText.intersection(rectOfReference)
            
            let isBelow: Bool = intersection.midY > rectOfText.midY
            print("{Onboarding} \(isBelow) \(rectOfReference) \(rectOfText) == \(intersection)")
            positioning = reference.frame.height * (isBelow ? -0.25 : 0.25)
        } else {
            positioning = 0
        }
        //
        
        if let textPadding = step.reference?.textPadding {
            positioning += textPadding
        }
        _view.messageCenterYConstraint?.update(offset: positioning)
    }
}
