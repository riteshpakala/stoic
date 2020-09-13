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
    
    private lazy var nextButtonGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer.init(target: self, action: #selector(self.nextButtonTapped(_:)))
    }()
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.parent = self.parent?.view
        _view.delegate = self
        _view.nextButton.addGestureRecognizer(nextButtonGesture)
        
        GraniteAppDelegate.AppUtility.lockToPortrait()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let reference = reference {
            _view.backgroundColor = reference.onboardingProperties.backgroundColor
            _view.onboardingMessageLabel.textColor = reference.onboardingProperties.textColor
            _view.onboardingMessageLabel.font = reference.onboardingProperties.textFont
            _view.onboardingMessage.backgroundColor = reference.onboardingProperties.textBackgroundColor
            
            _view.nextButton.textColor = reference.onboardingProperties.textColor
            _view.nextButton.font = reference.onboardingProperties.textFont
            _view.nextButton.backgroundColor = reference.onboardingProperties.textBackgroundColor
            
            let sizeOfNext = _view.nextButton.sizeThatFits(self._view.frame.size)
            _view.nextButtonWidthConstraint?.update(offset: sizeOfNext.width + 16)
            _view.nextButtonHeightConstraint?.update(offset: _view.nextButton.font.lineHeight + 6)
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        GraniteAppDelegate.AppUtility.toggleLockToLast()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard self._view.frame.size != self._view.layer.mask?.frame.size || currentStep.reference?.referenceFrame != component?.state.currentStep.reference?.referenceFrame else {
            return
        }
        setup(currentStep)
    }
    
    func viewTapped(inRegion: Bool) {
        
        guard !currentStepIsActionable, !currentStepCanContinue else {
            return
        }
        
        reference?.committedStep(self.currentStep.order)
        
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        var step: OnboardingStep?
        if  !inRegion && !self.currentStep.isActionable {
            step = getNextStep()
        }
        
        guard let nextStep = step else { return }

        _view.feedbackGenerator.impactOccurred()
        setup(nextStep)
    }
    
    @objc func nextButtonTapped(_ sender: UITapGestureRecognizer) {
        reference?.committedStep(self.currentStep.order)
        
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        _view.feedbackGenerator.impactOccurred()
        setup(getNextStep())
    }
}

extension OnboardingViewController: OnboardingActionableDelegate {
    public func commitAction() {
        guard !currentStepCanContinue else {
            _view.nextButton.isHidden = false
            return
        }
        
        reference?.committedStep(self.currentStep.order)
        
        guard !isLastStep else {
            self.component?.removeFromParent()
            return
        }
        
        guard
            currentStepIsActionable,
            currentStepCommittedAction else {
            return
        }
        
        setup(getNextStep())
    }
}

extension OnboardingViewController {
    func setup(_ step: OnboardingStep) {
        
        if step.isActionable {
            _view.doNotBubbleHits = false
            _view.nextButton.isHidden = true
        } else {
            _view.doNotBubbleHits = step.continuePreferred
            _view.nextButton.isHidden = step.isContinueHidden
        }
        
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
        _view.onboardingMessageLabel.text = step.text
        
        guard let reference = reference,
              let referenceFrame = step.reference?.referenceFrame else { return }
        let sizeOfText = _view.onboardingMessageLabel.sizeThatFits(reference.frame.size)
        let heightOfText = sizeOfText.height + 24
        _view.messageHeightConstraint?.update(offset: heightOfText)
        
        //
        //
        let rectOfReference: CGRect = referenceFrame
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
            
            let aboveArea = rectOfReference.origin.y
            let belowArea = (reference.frame.height - rectOfReference.maxY)
            
            let isBelow = belowArea > aboveArea
            
            let diff: CGFloat
            
            if isBelow {
                diff = belowArea - rectOfText.height
            } else {
                diff = aboveArea - rectOfText.height
            }
            
            let rect: CGRect = .init(origin: .init(x: rectOfText.origin.x, y: (isBelow ? rectOfReference.maxY : 0) + diff/2), size: rectOfText.size)
            
            let centerOfRect = rect.origin.y + (rect.height/2)
            
            positioning = (-reference.frame.height/2) + centerOfRect
            
            if !isBelow && !step.isContinueHidden {
                positioning -= _view.nextButton.frame.size.height + 2
            }
        } else {
            if !step.isContinueHidden {
                positioning = -_view.nextButton.frame.size.height + 2
            } else {
                positioning = 0
            }
        }
        //
        
        if let textPadding = step.reference?.textPadding {
            positioning += textPadding
        }
        _view.messageCenterYConstraint?.update(offset: positioning)
    }
}
