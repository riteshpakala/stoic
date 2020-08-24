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
        view.text = "Account // Free".localized.capitalized
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileStatsSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// Stats".localized.capitalized
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileAgeSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// Age".localized.capitalized
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var profileStocksSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// Stocks".localized.capitalized
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
            - 12 days old.
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
            - most searched stock: $TSLA
            - device's average error: 1%
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
        return view
    }()
    
    lazy var subscribeLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "subscribe".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
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
    
//    lazy var emailTapGesture: UITapGestureRecognizer = {
//        return UITapGestureRecognizer(
//            target: self,
//            action: #selector(self.emailTeamTapped(_:)))
//    }()
    
    public init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
