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
    lazy var signInLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "sign in with apple".localized
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
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
            make.height.equalTo(signInLabel.font.lineHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}
