//
//  Router.Onboarding.Detail.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

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
                predictionStepPart2,
                predictionStepPart3
            ]
        }
    }
    
    public var introStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            actionable: .init(keyPath: \.frame, view: self),
            text: "a prediction retrieves stock data & sentiment from all over the web. Give it a moment to pull & process",
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
        let cellHeight = consoleView.detailView.historicalView.cellHeight
        let cells = consoleView.detailView.historicalView.cellsToViewWhenExpanded - 1.0
        return OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.historicalView.historicDatePicker,
                containerView: consoleView.detailView.historicalView,
                padding: .init(
                    top: -consoleView.detailView.frame.origin.y,
                    left: 0,
                    bottom: cellHeight*cells,
                    right: 0)),
            actionable: .init(keyPath: \.layer.transform, view: self.consoleView.detailView.historicalView.indicator),
            text: "tap on another date; collapse it to continue",
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
            text: "adjust these sentiment knobs to get realtime predictions",
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
            order: 5,
            isContinueHidden: false)
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
            text: "tap the ball to provide a suggestion of sentiment. The web is filled with emotion, we're going to grab some based on the trading day",
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
            actionable: .init(keyPath: \.isHidden, view: self.consoleView.detailView.loaderView),
            text: "give it a moment to find valuable info to work with",
            order: 7)
    }
    
    public var predictionStepPart3: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.sentimentView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing + consoleView.detailView.predictionView.frame.height,
                    right: -GlobalStyle.spacing*2)),
            text: "after you are done, head to the `model browser` to see your stored, offline models",
            order: 8,
            isContinueHidden: false)
    }
    
    public func committedStep(_ index: Int) {
        if index == 7 {
            guard let superview = self.superview as? DashboardView else {
                return
            }
            superview.settings.open()
            superview.settings.showHelpers()
        }
    }
}
