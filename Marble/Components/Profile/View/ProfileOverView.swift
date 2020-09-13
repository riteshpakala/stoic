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
        view.textColor = GlobalStyle.Colors.green
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
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(subscribeTapGesture)
        return view
    }()
    
    lazy var emailLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "email: team@linenandsole.com\nfor feedback & suggestions".localized
        view.font = GlobalStyle.Fonts.courier(.small, .bold)
        view.textColor = GlobalStyle.Colors.purple
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.numberOfLines = 0
        view.addGestureRecognizer(emailTapGesture)
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
                .init(),
                stackViewDisclaimers,
                .init(),
                signOutLabel,
                emailLabel,
                subscribeLabel,
                spacer
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
    
    lazy var emailTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.emailTeamTapped(_:)))
    }()
    
    lazy var subscribeTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.subscribeTapped(_:)))
    }()
    
    lazy var signOutTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.signOutTapped(_:)))
    }()
    
    public var subscription: GlobalDefaults.Subscription = .none {
        didSet {
            updateSubscriptionAppearance()
        }
    }
    
    private var loader: ConsoleLoader?
    public init() {
        super.init(frame: .zero)
        loader = .init(self, baseText: "/**** loading\(ConsoleLoader.seperator) */")
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loader?.begin()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperties(_ properties: UserProperties) {
        loader?.stop()
        statsDescription1.text =
        """
        - \(properties.accountAge) days old
        """
        
        if properties.stockPredictions.isEmpty {
            statsDescription2.text =
            """
            - most searched stock: $\(properties.mostSearchedStock)
            """
        } else {
            statsDescription2.text =
            """
            - most searched stock: $\(properties.mostSearchedStock)
            - device's average error: \(round((properties.deviceAverageError)*100)/100)%
            """
        }
        
        statsDescription3.text =
            """
            - models trained: \(properties.stockModels.count)
            """
    }
    
    func updateSubscriptionAppearance() {
        if subscription.isActive {
            profileLabel.text = "* account".localized.lowercased()+" // PRO"
            subscribeLabel.isHidden = true
        } else {
            profileLabel.text = "* account".localized.lowercased()
            subscribeLabel.isHidden = false
        }
    }
    
    @objc func emailTeamTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        emailTeam()
    }
    
    @objc func subscribeTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubbleEvent(SubscribeEvents.Show())
    }
    
    @objc func signOutTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubble(ProfileEvents.SignOut())
    }
    
    func emailTeam() {
        let email = "team@linenandsole.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension ProfileOverView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        self.statsDescription1.text = indicator
        self.statsDescription2.text = indicator
        self.statsDescription3.text = indicator
    }
}
