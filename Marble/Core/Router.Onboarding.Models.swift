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

public protocol Onboardable: GraniteView {
    var onboardingSteps: [OnboardingStep] { get }
    var onboardingProperties: OnboardingProperties { get }
    func committedStep(_ index: Int)
}

extension Onboardable {
    public var onboardingProperties: OnboardingProperties {
        .init(
            backgroundColor: GlobalStyle.Colors.yellow.withAlphaComponent(0.15),
            textColor: GlobalStyle.Colors.yellow,
            textFont: GlobalStyle.Fonts.courier(.medium, .bold),
            textBackgroundColor: GlobalStyle.Colors.black.withAlphaComponent(0.75))
    }
}

//MARK: Dashboard
extension DashboardView: Onboardable {
    public var onboardingSteps: [OnboardingStep] {
        get {
            [
                settingsStep,
                settingsOverviewStep,
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
    
    public var settingsOverviewStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(top: 0, left: 0, bottom: 0, right: 100)),
            isActionable: false,
            text: "sentiment and the amount of days can be set to strengthen or quicken prediction results.",
            order: 1)
    }
    
    public var sentimentStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(top: 0, left: 0, bottom: 0, right: 100)),
            isActionable: false,
            text: "sentiment strengths define how much emotional data should be gathered for prediction accuracy. Higher settings will increase prediction generation.",
            order: 2)
    }
    
    public var daysStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(top: 0, left: 0, bottom: 0, right: 100)),
            isActionable: false,
            text: "you can set the days, of how far back in the market week data should be pulled to forecast the next trading day's stock.",
            order: 3)
    }
    
    public var searchStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self,
                padding: .init(
                    top: GlobalStyle.spacing,
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
                    top: GlobalStyle.spacing,
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

//MARK: Detail
extension DetailView: Onboardable {
    public var onboardingProperties: OnboardingProperties {
        .init(
            backgroundColor: GlobalStyle.Colors.yellow.withAlphaComponent(0.36),
            textColor: GlobalStyle.Colors.yellow,
            textFont: GlobalStyle.Fonts.courier(.subMedium, .bold),
            textBackgroundColor: GlobalStyle.Colors.black.withAlphaComponent(0.95))
    }
    
    public var onboardingSteps: [OnboardingStep] {
        get {
            [
                introStep,
                nextTradingDayStep,
                historicalDayStep,
                sentimentStepPart1,
                sentimentStepPart2,
                predictionStepPart1,
                predictionStepPart2
            ]
        }
    }
    
    public var introStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            isActionable: false,
            text: "A prediction retrieves stock data & sentiment from all over the web",
            order: 0)
    }
    
    public var nextTradingDayStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.headerView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: -GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing,
                    right: -GlobalStyle.spacing*2)),
            isActionable: false,
            text: "The trading date this window is predicting for",
            order: 1)
    }
    
    public var historicalDayStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.historicalView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: 0,
                    left: -GlobalStyle.spacing,
                    bottom: 0,
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "You can view data of past dates here, tap the arrow and tap a date",
            order: 2)
    }
    
    public var sentimentStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.sentimentView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing,
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "Adjust these sentiment knobs to get realtime predictions.",
            order: 3)
    }
    
    public var sentimentStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.sentimentView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing,
                    right: -GlobalStyle.spacing*2)),
            isActionable: false,
            text: "The middle is negative & positive weights. The left is used to refine. The right is used to remove potential bias",
            order: 4)
    }
    
    public var predictionStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.predictionView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: -GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: 0,
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "The prediction view shows the outcome of your judgement of the trading day's sentiment",
            order: 5)
    }
    
    public var predictionStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.predictionView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: -GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: 0,
                    right: -GlobalStyle.spacing*2)),
            isActionable: true,
            text: "Tap the ball to auto suggest based on live sentiment from the web.",
            order: 6)
    }
    
    
    public func committedStep(_ index: Int) {
        
    }
}
