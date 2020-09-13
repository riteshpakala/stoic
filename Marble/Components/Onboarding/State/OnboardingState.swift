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
    var index: Int = 0
    @objc dynamic var currentStep: OnboardingStep = .empty
}

extension OnboardingViewController {
    var isLastStep: Bool {
        (self.component?.state.index ?? 0) + 1 >= (self.reference?.onboardingSteps.count ?? 0)
    }
    
    var currentStepIsActionable: Bool {
        component?.state.currentStep.isActionable == true
    }
    
    var currentStepCanContinue: Bool {
        component?.state.currentStep.isContinueHidden == false
    }
    
    var currentStepCommittedAction: Bool {
        component?.state.currentStep.hasCommittedAction == true
    }
    
    var currentIndex: Int {
        component?.state.index ?? -1200000
    }
    
    var currentStep: OnboardingStep {
        guard  let index = self.component?.state.index,
               let reference = self.reference else {
            return .empty
        }
        
        return reference.onboardingSteps[index]
    }
    
    func getNextStep() -> OnboardingStep {
        guard let component = self.component,
              let reference = self.reference else { return .empty }
        
        var updateIndex: Int = component.state.index + 1
        if updateIndex >= reference.onboardingSteps.count {
            updateIndex = 0
        }
        
        return reference.onboardingSteps.first(
            where: { $0.order == updateIndex }) ?? .empty
    }
}
