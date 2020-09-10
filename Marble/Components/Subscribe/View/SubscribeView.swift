//
//  SubscribeView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class SubscribeView: GraniteView {
    
    lazy var subscribeLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "* subscription".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.purple
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var subscribeSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// benefits".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var subscriptionDescription: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            - search any stock
            - realtime `Stoic` user stock searches
            - personal stock search tracking
            - `high` Sentiment strength access
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
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
    
    lazy var stackViewSubscriptionOptions: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init()
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    lazy var stackViewDisclaimers: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init()
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                subscribeLabel,
                subscribeSubLabel,
                subscriptionDescription,
                .init(),
                stackViewDisclaimers,
                .init(),
                stackViewSubscriptionOptions,
                emailLabel,
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = GlobalStyle.Colors.black
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.bottom.equalToSuperview()
                .offset(-GlobalStyle.largePadding).priority(999)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    @objc func emailTeamTapped(_ sender: UITapGestureRecognizer) {
        emailTeam()
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

//class GraniteStackView: GraniteStackView, EventResponder {
//    var responder: EventResponder?
//
//    override func addSubview(_ view: UIView) {
//        super.addSubview(view)
//
//        if let graniteView = view as? EventResponder {
//            graniteView.responder = self
//        }
//    }
//
//    override func insertSubview(_ view: UIView, at index: Int) {
//        super.insertSubview(view, at: index)
//
//        if let graniteView = view as? EventResponder,
//            graniteView.responder == nil {
//            graniteView.responder = self
//        }
//    }
//}
