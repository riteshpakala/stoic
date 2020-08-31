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
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textColor = GlobalStyle.Colors.yellow
        label.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.75)
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        return label
    }()
    
    var messageCenterYConstraint: Constraint?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = GlobalStyle.Colors.yellow.withAlphaComponent(0.15)
        
        addSubview(onboardingMessage)
        onboardingMessage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.height.equalTo(onboardingMessage.font.lineHeight*5 + GlobalStyle.padding)
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
