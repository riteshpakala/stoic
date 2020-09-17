//
//  EULAVView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/16/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import Granite
import Firebase

class EULAView: UIStackView {
    lazy var thePrivacy: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.purple
        label.backgroundColor = .clear
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "privacy policy".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(privacyTapGesture)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
    }()
    
    lazy var theTerms: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.purple
        label.backgroundColor = .clear
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "terms & conditions".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(termsTapGesture)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
    }()
    
    var termsTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.termsTapped(_:)))
    }
    
    var privacyTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.privacyTapped(_:)))
    }
    
    lazy var spacer: UIView = {
        return .init()
    }()
    
    private var terms: String = "https://www.iubenda.com/terms-and-conditions/17232390"
    private var privacy: String = "https://www.iubenda.com/privacy-policy/17232390"
    
    public static var main: Database {
        Database.database(url: "https://stoic-45d04.firebaseio.com/")
    }
    
    init() {
        super.init(frame: .zero)
        self.addArrangedSubview(theTerms.container)
        self.addArrangedSubview(thePrivacy.container)
        
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = GlobalStyle.padding
        
        theTerms.container.snp.makeConstraints { make in
            make.height.equalTo(theTerms.label.font.lineHeight + 8)
        }
        
        thePrivacy.container.snp.makeConstraints { make in
            make.height.equalTo(thePrivacy.label.font.lineHeight + 8)
        }
        
        
        DispatchQueue.init(label: "stoic.contact.fetch").async { [weak self] in
            ContactView.main.reference()
                .child("eula")
                .observeSingleEvent(of: .value, with: { snapshot in
                
                    if let information = snapshot.value as? [String: String] {
                        self?.terms = information["terms"] ?? (self?.terms ?? "")
                        self?.privacy = information["privacy"] ?? (self?.privacy ?? "")
                    }
                
            })
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func termsTapped(_ sender: UITapGestureRecognizer) {
        impactOccured()
        openTerms()
    }
    
    @objc func privacyTapped(_ sender: UITapGestureRecognizer) {
        impactOccured()
        openPrivacy()
    }
    
    func openTerms() {
        if let url = URL(string: self.terms) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openPrivacy() {
        if let url = URL(string: self.privacy) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

