//
//  Contact.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import Granite
import Firebase

class ContactView: UIStackView {
    lazy var theEmail: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.black
        label.backgroundColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "email".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(emailTapGesture)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
    }()
    
    lazy var theDiscord: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textColor = GlobalStyle.Colors.black
        label.backgroundColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.text = "discord".lowercased()
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(discordTapGesture)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(label.frame.size.width + 24)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        return (view, label)
    }()
    
    var emailTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.emailTeamTapped(_:)))
    }
    
    var discordTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.discordTapped(_:)))
    }
    
    lazy var spacer: UIView = {
        return .init()
    }()
    
    private var email: String = "team@linenandsole.com"
    private var discord: String = "https://discord.gg/VFfE8PT"
    
    public static var main: Database {
        Database.database(url: "https://stoic-45d04.firebaseio.com/")
    }
    
    init() {
        super.init(frame: .zero)
        self.addArrangedSubview(theEmail.container)
        self.addArrangedSubview(theDiscord.container)
        
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = GlobalStyle.padding
        
        theDiscord.container.snp.makeConstraints { make in
            make.height.equalTo(theDiscord.label.font.lineHeight + 8)
        }
        
        theEmail.container.snp.makeConstraints { make in
            make.height.equalTo(theEmail.label.font.lineHeight + 8)
        }
        
        
        DispatchQueue.init(label: "stoic.contact.fetch").async { [weak self] in
            ContactView.main.reference()
                .child("contact")
                .observeSingleEvent(of: .value, with: { snapshot in
                
                    if let information = snapshot.value as? [String: String] {
                        self?.email = information["email"] ?? (self?.email ?? "")
                        self?.discord = information["discord"] ?? (self?.discord ?? "")
                    }
                
            })
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func emailTeamTapped(_ sender: UITapGestureRecognizer) {
        impactOccured()
        emailTeam()
    }
    
    @objc func discordTapped(_ sender: UITapGestureRecognizer) {
        impactOccured()
        openDiscord()
    }
    
    func emailTeam() {
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openDiscord() {
        if let url = URL(string: discord) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
