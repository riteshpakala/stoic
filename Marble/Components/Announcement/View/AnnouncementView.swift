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
        view.isHidden = true
        return view
    }()
    
    lazy var announcementTitleLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// ~".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.isHidden = true
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
            hello stoic
            """
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.isHidden = true
        return view
    }()
    
    lazy var theImage: UIImageView = {
        let view: UIImageView = .init()
        view.backgroundColor = .clear
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var thePrivacyTitle: UILabel = {
        let view: UILabel = .init()
        view.text = "// privacy".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    lazy var thePrivacy: UITextView = {
        let textViewTerms = UITextView()
        textViewTerms.translatesAutoresizingMaskIntoConstraints = false
        textViewTerms.backgroundColor = UIColor.clear
        textViewTerms.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        textViewTerms.textColor = GlobalStyle.Colors.purple
        textViewTerms.showsVerticalScrollIndicator = false
        textViewTerms.showsHorizontalScrollIndicator = false
        textViewTerms.isEditable = false
        textViewTerms.isHidden = true
        return textViewTerms
    }()
    
    lazy var thePrivacyAgree: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        view.isHidden = true
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.black
        label.backgroundColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "i agree".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
    }()
    
    lazy var theContinue: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        view.isHidden = true
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.black
        label.backgroundColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "continue".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
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
        view.isHidden = true
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                announcementLabel,
                announcementTitleLabel,
                theImage,
                theMessageLoadingLabel,
                theMessage,
                thePrivacyTitle,
                thePrivacy,
                thePrivacyAgree.container,
                theContinue.container,
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
        let view: UIView = .init()
        view.isHidden = true
        return view
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
        
        thePrivacyAgree.container.snp.makeConstraints { make in
            make.height.equalTo(thePrivacyAgree.label.font.lineHeight + 8)
        }
        
        theContinue.container.snp.makeConstraints { make in
            make.height.equalTo(theContinue.label.font.lineHeight + 8)
        }
        
        theImage.snp.makeConstraints { make in
            make.height.equalTo(AnnouncementStyle.imageHeight)
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
    
    func setupPrivacy() {
        let heightLeft = LSConst.Device.height - min(estimatedSize.width, estimatedSize.height)

        thePrivacy.snp.makeConstraints { make in
            make.height.equalTo((heightLeft > 0 && heightLeft < LSConst.Device.height && self.isIPhone) ? (heightLeft/2) - (GlobalStyle.largePadding*2) : AnnouncementStyle.privacyHeight)
        }
        
        thePrivacyTitle.isHidden = false
        thePrivacy.isHidden = false
        thePrivacyAgree.container.isHidden = false
        
        if let path = Bundle.main.path(forResource: "terms", ofType: "txt") {
            
            if let contents = try? String(contentsOfFile: path) {
                
                thePrivacy.text = contents
                
            } else {
                
                print("[TERMS] Error! - This file doesn't contain any text.")
            }
            
        } else {
            
            print("[TERMS] Error! - This file doesn't exist.")
        }
    }
    
    func updatePrivacyAppearance(landscape: Bool) {
        thePrivacyTitle.isHidden = landscape
        thePrivacy.isHidden = landscape
        thePrivacyAgree.container.isHidden = landscape
    }
    
    func updateAppearance(landscape: Bool) {
        if landscape {
            theImage.isHidden = true
        } else if theImage.image != nil {
            theImage.isHidden = false
        }
    }
    
    func setData(announcement: Announcement, image: UIImage? = nil, _ shouldWelcome: Bool) {
        announcementTitleLabel.text = "// "+announcement.title
        theMessage.text = announcement.message
        
        emailLabel.isHidden = false
        
        announcementLabel.isHidden = false
        announcementTitleLabel.isHidden = false
        theMessage.isHidden = false
        spacer.isHidden = false
        
        if let image = image {
            theImage.image = image
            theImage.isHidden = false
        }
        
        if shouldWelcome {
            setupPrivacy()
        } else {
            theContinue.container.isHidden = false
        }
    }
    
    var estimatedSize: CGSize {
        self.stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
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
        stackView.setNeedsLayout()
        theMessageLoadingLabel.isHidden = true
        loader?.stop()
    }
}
