//
//  Router.Onboarding.Dashboard.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

//MARK: Dashboard
extension DashboardView: Onboardable {
    public var onboardingSteps: [OnboardingStep] {
        get {
            [
                introStep,
                settingsStep,
                settingsOverviewStep,
                profileStep,
                modelBrowserStep,
                sentimentStep,
                daysStep,
                searchStep,
                searchSelectionStep
            ]
        }
    }
    
    public var introStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            text: "welcome to Stoic. Let's go through a quick guide to help adjust some expectations",
            order: 0,
            isContinueHidden: false)
    }
    
    public var settingsStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings.tongueView,
                containerView: self.settings),
            actionable: .init(keyPath: \.layer.transform, view: self.settings.indicator),
            text: "tap the arrow to view various ways you can control your experience within Stoic",
            order: 1)
    }
    
    public var settingsOverviewStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))),
            text: "profile\nsentiment strength\ndays to predict from",
            order: 2,
            isContinueHidden: false)
    }
    
    public var profileStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(
                    top: 0,
                    left: 0,
                    bottom: -(self.settings.container.frame.height*4/5),
                right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))),
            text: "profile is what it sounds like, view account stats that update on each forecast. longer you use this app the more interesting your device history will become",
            order: 3,
            isContinueHidden: false)
    }
    
    public var modelBrowserStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(
                    top: -self.settings.container.frame.height/5,
                    left: 0,
                    bottom: -(self.settings.container.frame.height*4/5),
                right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))),
            text: "your trained models are stored here & can be combined into larger, refined versions",
            order: 4,
            isContinueHidden: false)
    }
    
    public var sentimentStep: OnboardingStep {
        let padding: UIEdgeInsets = .init(
            top: -(self.settings.container.frame.height*2/5),
            left: 0,
            bottom: -(self.settings.container.frame.height*4/5),
            right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))
        
        let reference: OnboardingReference = OnboardingReference.init(
            referenceView: self.settings,
            fitsToBounds: true,
            padding: padding)
            
        return OnboardingStep.init(
            reference: reference,
            text: "sentiment strength modifies the intensity of how & how much data to process from the web regarding emotion. higher settings increases prediction time, but tends to lead to more accurate results",
            order: 5,
            isContinueHidden: false)
    }
    
    public var daysStep: OnboardingStep {
        let padding: UIEdgeInsets = .init(
            top: -(self.settings.container.frame.height*3/5),
            left: 0,
            bottom: -(self.settings.container.frame.height*4/5),
            right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))
        
        let reference: OnboardingReference = OnboardingReference.init(
            referenceView: self.settings,
            fitsToBounds: true,
            padding: padding)
            
        return OnboardingStep.init(
            reference: reference,
            text: "the number of days to learn from can be adjusted as well. from a day before the next valid trading window to 12 days to the past. prediction time greatly increases, especially if your sentiment strength is high. But, again... tends to lead to more interesting results",
            order: 6,
            isContinueHidden: false)
    }
    
    public var searchStep: OnboardingStep {
        return OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self,
                padding: .init(
                    top: self.safeAreaInsets.top + GlobalStyle.padding,
                    left: GlobalStyle.spacing,
                    bottom: 0.0,
                    right: -GlobalStyle.spacing*2),
                paddingPreferred: true),
            actionable: .init(keyPath: \.layer.bounds, view: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self),
            text: "you can search for most stocks using their $Ticker Symbol. give it a shot",
            order: 7)
    }
    
    public var searchSelectionStep: OnboardingStep {
        guard let search = self.subviews.first(
            where: { ($0 as? SearchView) != nil }) as? SearchView else {
                return .empty
        }
        return OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: search,
                padding: .init(
                    top: self.safeAreaInsets.top + GlobalStyle.padding,
                    left: GlobalStyle.spacing,
                    bottom: 0.0,
                    right: -GlobalStyle.spacing*2),
                paddingPreferred: true),
            actionable: .init(keyPath: \.layer.sublayers, view: self),
            text: "results would appear right below, tap one to begin a forecast",
            order: 8)
    }
    
    public func committedStep(_ index: Int) {
        if index == 1 {
            self.settings.showHelpers(forceActive: true)
        }else if index == 6 {
            self.bringSubviewToFront(self.settings)
            self.settings.showHelpers(forceHide: true)
            self.settings.collapse()
        }
    }
}
