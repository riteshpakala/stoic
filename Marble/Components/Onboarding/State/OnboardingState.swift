//
//  OnboardingState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public class OnboardingState: State {
    var currentStep: Int = 0
}

extension OnboardingViewController {
    var isLastStep: Bool {
        (self.component?.state.currentStep ?? 0) + 1 >= (self.reference?.onboardingSteps.count ?? 0)
    }
    
    var currentStep: OnboardingStep {
        guard  let index = self.component?.state.currentStep,
               let reference = self.reference else {
            return .empty
        }
        
        return reference.onboardingSteps[index]
    }
    
    func getNextStep() -> OnboardingStep {
        guard let component = self.component,
              let reference = self.reference else { return .empty }
        
        var updateStep: Int = component.state.currentStep + 1
        if updateStep >= reference.onboardingSteps.count {
            updateStep = 0
        }
        
        component.sendEvent(
            OnboardingEvents.UpdateStep.init(step: updateStep))
        
        return reference.onboardingSteps.first(
            where: { $0.order == updateStep }) ?? .empty
    }
}
