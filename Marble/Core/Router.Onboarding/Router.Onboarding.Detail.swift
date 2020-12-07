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
                modelSelectorStepPart1,
                modelSelectorStepPart2,
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
            actionable: .init(keyPath: \.isHidden, view: self.consoleView.detailView),
            text: "a prediction retrieves stock data & sentiment from all over the web. Give it a moment to pull & process",
            order: 0)
    }
    
    public var modelSelectorStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.modelPickerView,
                containerView: consoleView.detailView,
                padding: .init(
                    top: 0,
                    left: -GlobalStyle.spacing,
                    bottom: 0,
                    right: -GlobalStyle.spacing*2)),
            actionable: .init(keyPath: \.layer.transform, view: self.consoleView.detailView.modelPickerView.indicator),
            text: "multiple models are generated, tap the triangle",
            order: 1)
    }
    
    public var modelSelectorStepPart2: OnboardingStep {
        let cellHeight = consoleView.detailView.modelPickerView.cellHeight
        let cells = consoleView.detailView.modelPickerView.cellsToViewWhenExpanded - 1.0
        return OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.modelPickerView.modelPicker,
                containerView: consoleView.detailView.modelPickerView,
                padding: .init(
                    top: -consoleView.detailView.frame.origin.y,
                    left: 0,
                    bottom: cellHeight*cells,
                    right: 0)),
            actionable: .init(keyPath: \.layer.transform, view: self.consoleView.detailView.modelPickerView.indicator),
            text: "tap on another model for a stock characteristic; collapse it to continue",
            order: 2)
    }
    
    public var sentimentStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.hStack,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing,
                    right: -GlobalStyle.spacing*2)),
            actionable: .init(keyPath: \.isHidden, view: self.consoleView.detailView.sentimentView.refineLabel),
            text: "adjust these sentiment knobs to get realtime predictions",
            order: 3)
    }
    
    public var sentimentStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.hStack,
                containerView: consoleView.detailView,
                padding: .init(
                    top: GlobalStyle.spacing,
                    left: -GlobalStyle.spacing,
                    bottom: GlobalStyle.spacing,
                    right: -GlobalStyle.spacing*2)),
            text: "the middle is negative & positive weights. The left is used to refine. The right is used to remove potential bias",
            order: 4,
            isContinueHidden: false)
    }
    
    public var predictionStepPart1: OnboardingStep {
        OnboardingStep.init(
            reference: .init(
                referenceView: consoleView.detailView.hStack,
                containerView: consoleView.detailView,
                padding: .zero),
            actionable: .init(keyPath: \.layer.sublayers, view: self.consoleView.detailView.predictionView.thinkTriggerContainer),
            text: "tap the ball to provide a suggestion for the day following your last prediction day.",
            order: 5)
    }
    
    public var predictionStepPart2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            text: "the accuracy may decrease if more days are added than the amount of days trained.",
            order: 6,
            isContinueHidden: false)
    }
    
    public var predictionStepPart3: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            text: "after you are done, head to the `model browser` to see your stored, offline, models",
            order: 7,
            isContinueHidden: false)
    }
    
    public func committedStep(_ index: Int) {
        if index == 6 {
            guard let superview = self.superview as? DashboardView else {
                return
            }
            superview.settings.open()
            superview.settings.showHelpers()
        }
    }
}
