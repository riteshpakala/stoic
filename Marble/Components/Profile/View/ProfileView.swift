//
//  ProfileView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class ProfileView: GraniteView {
    lazy var signInLabel: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.image = UIImage.init(named: "appleid.button")
        view.layer.shadowColor = GlobalStyle.Colors.green.withAlphaComponent(0.66).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 4.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    lazy var profileOverView: ProfileOverView = {
        let view: ProfileOverView = .init()
        view.isHidden = true
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = GlobalStyle.Colors.black
        
        addSubview(profileOverView)
        profileOverView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
                .offset(-GlobalStyle.largePadding).priority(999)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.largePadding).priority(999)
        }
        
        addSubview(signInLabel)
        signInLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(ProfileStyle.appleButtonHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    func signInPressed() {
        signInLabel.layer.shadowColor = GlobalStyle.Colors.purple.withAlphaComponent(0.66).cgColor
        signInLabel.alpha = 0.5
    }
    
    func resetSignIn() {
        signInLabel.layer.shadowColor = GlobalStyle.Colors.green.withAlphaComponent(0.66).cgColor
        signInLabel.alpha = 1.0
    }
}
