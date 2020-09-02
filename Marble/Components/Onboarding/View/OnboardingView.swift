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
    
    lazy var onboardingMessage: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = .yellow
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        return label
    }()
    
    var messageCenterYConstraint: Constraint?
    var messageHeightConstraint: Constraint?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .yellow
        
        addSubview(onboardingMessage)
        onboardingMessage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            messageHeightConstraint = make.height.equalTo(onboardingMessage.font.lineHeight*5 + 12).constraint
            make.centerX.equalToSuperview()
            messageCenterYConstraint = make.centerY.equalToSuperview().constraint
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
        
        if regionOfTheCurrent.contains(point) {
            return parent
        } else {
            return super.hitTest(point, with: event)
        }
    }
}
