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
                profileStep,
                modelBrowserStep,
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
            actionable: .init(keyPath: \.layer.transform, view: self.settings.indicator),
            text: "tap the arrow to view various options that control your experience in Stoic.",
            order: 0)
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
            order: 1)
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
            order: 2)
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
            order: 3)
    }
    
    public var sentimentStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(
                    top: -(self.settings.container.frame.height*2/5),
                    left: 0,
                    bottom: -(self.settings.container.frame.height*4/5),
                right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))),
            text: "sentiment strength modifies the intensity of how & how much data to process from the web regarding emotion. higher settings increases prediction time, but tends to lead to more accurate results",
            order: 4)
    }
    
    public var daysStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.settings,
                fitsToBounds: true,
                padding: .init(
                    top: -(self.settings.container.frame.height*3/5),
                    left: 0,
                    bottom: -(self.settings.container.frame.height*4/5),
                right: -abs(self.settings.container.frame.width - self.settings.tongueView.frame.width))),
            text: "the number of days to learn from can be adjusted as well. from a day before the next valid trading window to 12 days to the past. prediction time greatly increases, especially if your sentiment strength is high. But, again... tends to lead to more interesting results",
            order: 5)
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
            actionable: .init(keyPath: \.layer.bounds, view: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self),
            text: "you can search for most stocks using their $Ticker Symbol. give it a shot",
            order: 6)
    }
    
    public var searchSelectionStep: OnboardingStep {
        OnboardingStep.init(
            reference: OnboardingReference.init(
                referenceView: self.subviews.first(where: { ($0 as? SearchView) != nil }) ?? self,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.padding,
                    right: -(GlobalStyle.padding+GlobalStyle.spacing))),
            actionable: .init(keyPath: \.layer.sublayers, view: self),
            text: "results would appear right below, tap one to begin a forecast.",
            order: 7)
    }
    
    public func committedStep(_ index: Int) {
//        if index <= 3 {
//            self.settings.showHelpers(forceActive: true)
        if index == 5 {
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
                historicalDayStepPart1,
                historicalDayStepPart2,
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
            actionable: .init(keyPath: \.frame, view: self),
            text: "a prediction retrieves stock data & sentiment from all over the web. Give it a moment to pull & process.",
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
            text: "the trading date this window is predicting for",
            order: 1)
    }
    
    public var historicalDayStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.historicalView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: 0,
                    left: -GlobalStyle.spacing,
                    bottom: 0,
                    right: -GlobalStyle.spacing*2)),
            actionable: .init(keyPath: \.layer.transform, view: self.consoleView.detailView.historicalView.indicator),
            text: "you can view data of past dates here, tap the triangle",
            order: 2)
    }
    
    public var historicalDayStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.historicalView.historicDatePicker,
                containerView: consoleView.detailView.historicalView,
                padding: .init(
                    top: -consoleView.detailView.frame.origin.y,
                    left: 0,
                    bottom: 0,
                    right: 0)),
            actionable: .init(keyPath: \.layer.transform, view: self.consoleView.detailView.historicalView.indicator),
            text: "tap on another date",
            order: 3)
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
            actionable: .init(keyPath: \.isHidden, view: self.consoleView.detailView.sentimentView.refineLabel),
            text: "adjust these sentiment knobs to get realtime predictions.",
            order: 4)
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
            text: "the middle is negative & positive weights. The left is used to refine. The right is used to remove potential bias",
            order: 5)
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
            actionable: .init(keyPath: \.layer.sublayers, view: self.consoleView.detailView.predictionView.thinkTriggerContainer),
            text: "tap the ball to provide a suggestion of sentiment. The web is filled with emotion, we're going to grab some based on the trading day.",
            order: 6)
    }
    
    public var predictionStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.sentimentView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing + consoleView.detailView.predictionView.frame.height,
                    right: -GlobalStyle.spacing*2)),
            actionable: .init(keyPath: \.layer.sublayers, view: self.consoleView.detailView.predictionView.thinkTriggerContainer),
            text: "give it a moment to find valuable info to work with.",
            order: 7)
    }
    
    
    public func committedStep(_ index: Int) {
        
    }
}
