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
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if _view.frame.size != _view.layer.mask?.frame.size {
            setup(currentStep)
        }
    }
    
    func viewTapped(inRegion: Bool) {
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        var step: OnboardingStep?
        if  inRegion,
            self.currentStep.isActionable {
            
            if !self.currentStep.hasCommittedAction {
                self.currentStep.hasCommittedAction = true
            }
            step = getNextStep()
        } else if !inRegion && !self.currentStep.isActionable {
            step = getNextStep()
        }
        
        guard let nextStep = step else { return }
        reference?.committedStep(self.currentStep.order)
        setup(nextStep)
    }
}

extension OnboardingViewController {
    func setup(_ step: OnboardingStep) {
        mask(step)
        applyText(step)
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
        _view.messageHeightConstraint?.update(offset: sizeOfText.height + 24)
        
        let yPadding = step.reference?.containerView?.frame.origin.y ?? 0
        let rectOfText = CGRect.init(
            origin: .init(
                x: _view.onboardingMessage.frame.origin.x,
                y: _view.onboardingMessage.frame.origin.y - (yPadding + (sizeOfText.height + 24)/2)),
            size: CGSize.init(
                width: _view.onboardingMessage.frame.size.width,
                height: sizeOfText.height + 24))
        
        if  rectOfText.intersects(referenceFrame) {

            var positioning = reference.frame.height * (referenceFrame.midY > reference.frame.height/2 ? -0.25 : 0.25)
            
            if let textPadding = step.reference?.textPadding {
                positioning += textPadding
            }
            
            _view.messageCenterYConstraint?.update(offset: positioning)
        } else {
            let rectOfTextCentered = CGRect.init(
                origin: .init(
                    x: _view.onboardingMessage.frame.origin.x,
                    y: reference.frame.height/2 - (yPadding + (sizeOfText.height + 24)/2)),
                size: CGSize.init(
                    width: _view.onboardingMessage.frame.size.width,
                    height: sizeOfText.height + 24))
            
            guard !rectOfTextCentered.intersects(referenceFrame) else { return }
            var positioning: CGFloat = 0
            if let textPadding = step.reference?.textPadding {
                positioning += textPadding
            }
            
            _view.messageCenterYConstraint?.update(offset: positioning)
        }
    }
}
