//
//  AnnouncementView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class AnnouncementView: GraniteView {
    lazy var announcementLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "* announcement".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.purple
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var theMessageLoadingLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.text = "/**** loading... */"
        return label
    }()
    
    lazy var theMessage: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            hello all
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var thePrivacy: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            hello all
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var thePrivacyAgree: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            hello all
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var theContinue: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            hello all
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.isHidden = true
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
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                announcementLabel,
                theMessageLoadingLabel,
                theMessage,
                thePrivacy,
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
    
    
    private var loader: ConsoleLoader?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        loader = .init(self, baseText: "/**** loading\(ConsoleLoader.seperator) */")
        
        backgroundColor = GlobalStyle.Colors.black
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
                .offset(-GlobalStyle.largePadding).priority(999)
            make.bottom.equalToSuperview().priority(999)
        }
        
        beginLoader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    @objc func emailTeamTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
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

extension AnnouncementView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        theMessageLoadingLabel.text = indicator
    }
    
    public func beginLoader() {
        loader?.begin()
    }
    
    public func stopLoader() {
        theMessageLoadingLabel.isHidden = true
        loader?.stop()
    }
}
