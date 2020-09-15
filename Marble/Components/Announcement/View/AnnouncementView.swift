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
    
    lazy var contact: ContactView = {
        let view: ContactView = .init()
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
                contact,
                spacer,
                theAlert.container
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        view.setCustomSpacing(GlobalStyle.padding, after: theContinue.container)
        
        return view
    }()
    
    lazy var spacer: UIView = {
        let view: UIView = .init()
        view.isHidden = true
        return view
    }()
    
    lazy var theAlert: (container: UIView, label: UILabel, dismiss: UILabel) = {
        let container: UIView = .init()
        container.isHidden = true
        
        let effect: UIVisualEffect = UIBlurEffect.init(style: .regular)
        let blur: UIVisualEffectView = .init(effect: effect)
        blur.alpha = 0.66
        container.addSubview(blur)
        blur.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let view: UILabel = .init()
        view.text =
            """
            hello stoic
            """
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.yellow
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        
        container.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalStyle.largePadding)
            make.right.equalToSuperview().offset(-GlobalStyle.largePadding)
        }
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.black
        label.backgroundColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "close".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalTo(label.frame.size.height + 8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(container.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.padding)
        }
        
        return (container, view, label)
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
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).priority(999)
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
    
    func setupAlert(_ message: String) {
        stackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for view in stackView.arrangedSubviews {
            view.isHidden = true
        }
        theAlert.container.isHidden = false
        theAlert.label.text = message
        stackView.setNeedsLayout()
        
        backgroundColor = .clear
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
        
        contact.isHidden = false
        
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
        
        stackView.setNeedsLayout()
        contact.setNeedsLayout()
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
