//
//  ProfileOverView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class ProfileOverView: GraniteView {
    lazy var profileLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "* account".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.purple
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileStatsSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// stats".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileAgeSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// age".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileStocksSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// stocks".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileModelsSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// models".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var statsDescription1: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            /**** loading... */
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        return view
    }()
    
    lazy var statsDescription2: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            /**** loading... */
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        return view
    }()
    
    lazy var statsDescription3: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            /**** loading... */
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        return view
    }()
    
    lazy var signOutLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "sign out".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.red
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(signOutTapGesture)
        return view
    }()
    
    lazy var subscribeLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "subscribe".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.alpha = 0.5
        view.addGestureRecognizer(subscribeTapGesture)
        return view
    }()
    
    lazy var restoreLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "restore purchases".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.alpha = 0.5
        view.addGestureRecognizer(restoreTapGesture)
        return view
    }()
    
    lazy var onboardingLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "reset onboarding".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(onboardingTapGesture)
        return view
    }()
    
    lazy var contact: ContactView = {
        let view: ContactView = .init()
        return view
    }()
    
    lazy var stackViewDisclaimers: UIStackView = {
        let view: UIStackView = UIStackView.init()
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    lazy var loaderRestoreView: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.green.withAlphaComponent(0.36)
        
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.text = "/**** restoring... */"
        label.sizeToFit()
        label.backgroundColor = GlobalStyle.Colors.black
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(label.font.lineHeight + 8)
            make.width.equalTo(label.frame.size.width + GlobalStyle.padding)
            make.center.equalToSuperview()
        }
        view.isHidden = true
        
        return (view, label)
    }()
    
    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView.init(
            arrangedSubviews: [
                profileLabel,
                profileStatsSubLabel,
                profileAgeSubLabel,
                statsDescription1,
                profileStocksSubLabel,
                statsDescription2,
                profileModelsSubLabel,
                statsDescription3,
                spacer,
                stackViewDisclaimers,
                onboardingLabel,
                subscribeLabel,
                restoreLabel,
                signOutLabel,
                contact
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        
        return view
    }()
    
    lazy var spacer: UIView = {
        return .init()
    }()
    
    var subscribeTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.subscribeTapped(_:)))
    }
    
    var restoreTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.restoreTapped(_:)))
    }
    
    var signOutTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.signOutTapped(_:)))
    }
    
    var onboardingTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.onboardingTapped(_:)))
    }
    
    public var subscription: GlobalDefaults.Subscription = .none {
        didSet {
            updateSubscriptionAppearance()
        }
    }
    
    public var subscriptionUpdated: Bool = false {
        didSet {
            if subscriptionUpdated {
                subscribeLabel.isUserInteractionEnabled = true
                subscribeLabel.alpha = 1.0
                restoreLabel.isUserInteractionEnabled = true
                restoreLabel.alpha = 1.0
                loaderRestoreView.container.isHidden = true
                
                if isRestoring {
                    self.loader?.stop()
                    isRestoring = false
                }
            } else {
                subscribeLabel.isUserInteractionEnabled = false
                subscribeLabel.alpha = 0.5
                restoreLabel.isUserInteractionEnabled = false
                restoreLabel.alpha = 0.5
            }
        }
    }
    
    private var loader: ConsoleLoader?
    private var isRestoring: Bool = false
    public init() {
        super.init(frame: .zero)
        loader = .init(self, baseText: "/**** loading\(ConsoleLoader.seperator) */")
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
                .offset(-GlobalStyle.largePadding).priority(999)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.largePadding).priority(999)
        }
        signOutLabel.snp.makeConstraints { make in
            make.height.equalTo(signOutLabel.font.lineHeight)
        }
        
        addSubview(loaderRestoreView.container)
        loaderRestoreView.container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loader?.begin()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperties(_ properties: UserProperties) {
        loader?.stop()
        
        DispatchQueue.main.async {
            self.statsDescription1.text =
            """
            - \(properties.accountAge) days old
            """
            
            if properties.stockPredictions.isEmpty {
                self.statsDescription2.text =
                """
                - most searched stock: $\(properties.mostSearchedStock)
                """
            } else {
                self.statsDescription2.text =
                """
                - most searched stock: $\(properties.mostSearchedStock)
                - device's average error: \(round((properties.deviceAverageError)*100)/100)%
                """
            }
            
            self.statsDescription3.text =
                """
                - models trained: \(properties.stockModels.count)
                """
        }
    }
    
    func updateSubscriptionAppearance() {
        if subscription.isActive {
            profileLabel.text = "* account".localized.lowercased()+" // PRO"
            subscribeLabel.isHidden = true
            restoreLabel.isHidden = true
        } else {
            profileLabel.text = "* account".localized.lowercased()
            subscribeLabel.isHidden = false
            restoreLabel.isHidden = false
        }
    }
    
    @objc func subscribeTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubbleEvent(SubscribeEvents.Show())
    }
    
    @objc func restoreTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubbleEvent(SubscribeEvents.Refresh())
        isRestoring = true
        loaderRestoreView.container.isHidden = false
        loader?.stop()
        loader = .init(self, baseText: "/**** restoring\(ConsoleLoader.seperator) */")
        loader?.begin()
    }
    
    @objc func signOutTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubble(ProfileEvents.SignOut())
    }
    
    @objc func onboardingTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubble(ProfileEvents.ResetOnboarding())
    }
    
    func updateAppearance(landscape: Bool) {
        if landscape {
            stackViewDisclaimers.isHidden = true
            onboardingLabel.isHidden = true
            contact.isHidden = true
        } else {
            stackViewDisclaimers.isHidden = false
            onboardingLabel.isHidden = false
            contact.isHidden = false
        }
    }
}

extension ProfileOverView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        guard loader?.isLoading == true else { return }
        if isRestoring {
            self.loaderRestoreView.label.text = indicator
        } else {
            self.statsDescription1.text = indicator
            self.statsDescription2.text = indicator
            self.statsDescription3.text = indicator
        }
    }
}
