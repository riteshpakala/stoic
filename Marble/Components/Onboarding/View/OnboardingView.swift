//
//  OnboardingView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

protocol OnboardingViewDelegate: class {
    func viewTapped(inRegion: Bool)
}

public class OnboardingView: GraniteView {
    var currentStepRegion: CGRect = .zero {
        didSet {
            if oldValue == .zero {
                lastStepRegion = currentStepRegion
            } else {
                lastStepRegion = oldValue
            }
        }
    }
    private var lastStepRegion: CGRect = .zero
    var parent: UIView?
    weak var delegate: OnboardingViewDelegate?
    var debounceInterval: Double = 0.5
    var lastInteractionTime: Double = CACurrentMediaTime()
    var doNotBubbleHits: Bool = false
    
    lazy var onboardingMessage: UIView = {
        let view: UIView = .init()
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var onboardingMessageLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = .yellow
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var nextButton: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = .yellow
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "continue".localized.lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var messageCenterYConstraint: Constraint?
    var messageHeightConstraint: Constraint?
    var nextButtonWidthConstraint: Constraint?
    var nextButtonHeightConstraint: Constraint?
    var nextButtonTopConstraint: Constraint?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .yellow
        
        addSubview(onboardingMessage)
        onboardingMessage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            messageHeightConstraint = make.height.equalTo(onboardingMessageLabel.font.lineHeight*5 + 12).constraint
            make.centerX.equalToSuperview()
            messageCenterYConstraint = make.centerY.equalToSuperview().constraint
        }
        
        onboardingMessage.addSubview(onboardingMessageLabel)
        onboardingMessageLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(2)
            make.bottom.right.equalToSuperview().offset(-2)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            nextButtonWidthConstraint = make.width.equalTo(nextButton.frame.size.width + 12).constraint
            nextButtonHeightConstraint = make.height.equalTo(nextButton.font.lineHeight + 2).constraint
            make.centerX.equalTo(onboardingMessage.snp.centerX)
            nextButtonTopConstraint = make.top.equalTo(onboardingMessage.snp.bottom).offset(6).constraint
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    override public func hitTest(
        _ point: CGPoint,
        with event: UIEvent?) -> UIView? {

        let regionOfTheCurrent: CGRect = currentStepRegion
        if CACurrentMediaTime() - lastInteractionTime >= debounceInterval {
            lastInteractionTime = CACurrentMediaTime()
            
            delegate?.viewTapped(inRegion: regionOfTheCurrent.contains(point))
        }
        
        if regionOfTheCurrent.contains(point), !doNotBubbleHits {
            return parent
        } else {
            return super.hitTest(point, with: event)
        }
    }
}
