//
//  Router.Onboarding.Browser.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite

//MARK: Browser
extension BrowserView: Onboardable {
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
                introStep2,
                loadStep,
                createStep,
                createStep2,
                createStep3,
                createStep4,
                createStep5
            ]
        }
    }
    
    public var introStep: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            text: "the models you train are stored here. On the device & never uploaded to a server, so keep your device safe",
            order: 0,
            isContinueHidden: false)
    }
    
    public var introStep2: OnboardingStep {
        OnboardingStep.init(
            reference: .init(textPadding: GlobalStyle.padding),
            text: "the models you train can then be merged to build larger, more precise models depending on the various settings and combinations you come up with",
            order: 1,
            isContinueHidden: false)
    }
    
    public var loadStep: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.collection.view,
                containerView: self.collection.view,
                padding: .init(
                    top: self.stackView.frame.origin.y,
                    left: -self.stackView.frame.origin.x/2,
                    bottom: 0,
                    right: self.stackView.frame.origin.x)
            ),
            text: "tapping on a model will load it instantly from memory, you can try it out after the tutorial",
            order: 2,
            isContinueHidden: false,
            continuePreferred: true)
    }
    
    public var createStep: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.compiledStackView,
                containerView: self.collection.view,
                padding: .init(
                    top: -(self.stackView.frame.origin.y - GlobalStyle.padding),
                    left: -self.stackView.frame.origin.x/2,
                    bottom: 0,
                    right: self.stackView.frame.origin.x)
            ),
            text: "tapping on `create` will allow you merge more than 1 together, if compatible. So 2 `1 day` models can become 1 `2 day` model",
            order: 3,
            isContinueHidden: false,
            continuePreferred: true)
    }
    
    public var createStep2: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.compiledStackView,
                containerView: self.collection.view,
                padding: .init(
                    top: -(self.stackView.frame.origin.y - GlobalStyle.padding),
                    left: -self.stackView.frame.origin.x/2,
                    bottom: 0,
                    right: self.stackView.frame.origin.x)
            ),
            actionable: .init(keyPath: \.isHidden, view: cell.compiledStackView),
            text: "even if you do not have more than 1 model yet, let's give it a try to see what's next. Tap `create` to continue",
            order: 4)
    }
    
    public var createStep3: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        guard let cell2 = cell.collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelDataContainerCell else {
            
            return .empty
        }
        
        let yOffset = cell.tickerContainer.frame.maxY + self.stackView.frame.origin.y + GlobalStyle.largePadding 
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.collection.view,
                padding: .init(
                    top: yOffset,
                    left: -self.stackView.frame.origin.x/2,
                    bottom: GlobalStyle.spacing/2,
                    right: self.stackView.frame.origin.x)
            ),
            actionable: .init(keyPath: \.layer.sublayers, view: cell2.collection.view),
            text: "the first step will require you to choose a `base model`. The following models selected will stack on top",
            order: 5)
    }
    
    public var createStep4: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.collection.view,
                containerView: self.collection.view,
                padding: .init(
                    top: self.stackView.frame.origin.y,
                    left: -self.stackView.frame.origin.x/2,
                    bottom: 0,
                    right: self.stackView.frame.origin.x)
            ),
            text: "if you have more than 1 model, you will be able to see a realtime update of what is compatible & what is not with the `base model`",
            order: 6,
            isContinueHidden: false,
            continuePreferred: true)
    }
    
    public var createStep5: OnboardingStep {
        guard let cell = collection.view.cellForItem(at: IndexPath.init(item: 0, section: 0)) as? BrowserModelCell else {
            
            return .empty
        }
        
        let yOffset = self.stackView.frame.origin.y
        
        return OnboardingStep.init(
            reference: .init(
                referenceView: cell.compiledCreateDetailsContainerView,
                containerView: self.collection.view,
                padding: .init(
                    top: -yOffset,
                    left: -self.stackView.frame.origin.x/2,
                    bottom: 0,
                    right: self.stackView.frame.origin.x)
            ),
            text: "tapping done & progressing through, will lead to the completion of the merge",
            order: 7,
            isContinueHidden: false,
            continuePreferred: true)
    }
    
    
    public func committedStep(_ index: Int) {
        
    }
}
