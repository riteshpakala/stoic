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

        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setup(currentStep)
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
        if let referenceFrame = nextStep.reference?.referenceFrame,
            (_view.onboardingMessage.frame.intersects(referenceFrame)) {
            
            _view.messageCenterYConstraint?.update(offset: UIScreen.main.bounds.height * (referenceFrame.origin.y > _view.onboardingMessage.frame.origin.y ? 0.5 : 1.5))
        }
        
        setup(nextStep)
    }
}

extension OnboardingViewController {
    func setup(_ step: OnboardingStep) {
        mask(step)
        
        _view.onboardingMessage.text = step.text
    }
    
    func mask(_ step: OnboardingStep) {
        guard let reference = step.reference else { return }
        let maskLayer = CAShapeLayer()
        maskLayer.frame = _view.layer.bounds
        let highlightPath = UIBezierPath.init(
            roundedRect: reference.referenceFrame,
            cornerRadius: 8)
        let mainPath = UIBezierPath.init(rect: _view.layer.bounds)
        print("{TEST} \(reference.referenceFrame)")
        mainPath.append(highlightPath)
        maskLayer.path = mainPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        _view.layer.mask = maskLayer
        _view.currentStepRegion = reference.referenceFrame
    }
}
