//
//  Router.Onboarding.Models.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import Firebase

//MARK: Onboarding
extension ServiceCenter.OnboardingService {
    
}

public protocol Onboardable {
    var onboardingSteps: [OnboardingStep] { get }
    func committedStep(_ index: Int)
}

extension DashboardView: Onboardable {
    public var onboardingSteps: [OnboardingStep] {
        get {
            [
                settingsStep,
                sentimentStep,
                daysStep,
                searchStep,
                searchSelectionStep
            ]
        }
    }
    
    public var settingsStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings.tongueView,
                containerView: self.settings),
            isActionable: true,
            text: "tap the arrow to open your profile or settings for your possible predictions.",
            order: 0)
    }
    
    public var sentimentStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(top: 0, left: 0, bottom: 0, right: 100)),
            isActionable: false,
            text: "sentiment and the amount of days can be set to strengthen or quicken prediction results.",
            order: 1)
    }
    
    public var daysStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(top: 0, left: 0, bottom: 0, right: 100)),
            isActionable: false,
            text: "sentiment strengths define how much emotional data should be gathered for prediction accuracy. Higher settings will increase prediction generation.",
            order: 3)
    }
    
    public var searchStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self,
                padding: .init(
                    top: -GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: (GlobalStyle.spacing*2),
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "you can search for most stocks using their $Ticker Symbol.",
            order: 4)
    }
    
    public var searchSelectionStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self,
                padding: .init(
                    top: -GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: SearchStyle.collectionHeight.height + (GlobalStyle.spacing*2),
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "Results would appear right below, tap one to begin a forecast.",
            order: 5)
    }
    
    public func committedStep(_ index: Int) {
        if index <= 3 {
            self.settings.showHelpers(forceActive: true)
        } else if index == 4 {
            self.settings.showHelpers(forceHide: true)
            self.settings.collapse()
        }
    }
}
